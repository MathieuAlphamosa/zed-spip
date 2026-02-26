# CLAUDE.md — zed-spip

## Projet

Extension Zed pour le langage de squelettes SPIP (CMS français).
Fournit coloration syntaxique, snippets, indentation, bracket matching et outline.
Utilise la grammaire [tree-sitter-spip](https://github.com/MathieuAlphamosa/tree-sitter-spip).

## Structure du projet

```
zed-spip/
├── extension.toml                    # Manifeste de l'extension (id, grammaire, snippets)
├── languages/spip/
│   ├── config.toml                   # Config langage (suffixes, commentaires, tabs)
│   ├── highlights.scm                # Coloration syntaxique (FICHIER CRITIQUE)
│   ├── injections.scm                # Injection HTML dans les nœuds content
│   ├── brackets.scm                  # Bracket matching
│   ├── indents.scm                   # Règles d'indentation
│   └── outline.scm                   # Panneau outline (boucles, includes)
├── snippets/spip.json                # 170+ snippets
├── scripts/patch-emmet.sh            # Script pour ajouter SPIP à l'extension Emmet
├── grammars/                         # Cache WASM compilé (gitignored, à supprimer pour forcer recompilation)
└── README.md
```

## Commandes et workflow

### Installer en mode dev

Dans Zed : `Cmd+Shift+P` > "Extensions: Install Dev Extension" > sélectionner le dossier `zed-spip/`.

### Après modification de highlights.scm ou config.toml

Redémarrer Zed (`Cmd+Q` puis relancer). Les changements de highlights.scm sont rechargés au redémarrage.

### Après modification de la grammaire tree-sitter-spip

1. Dans tree-sitter-spip : `npx tree-sitter generate && npx tree-sitter test`
2. Committer et pousser tree-sitter-spip
3. Copier le hash complet du commit : `git rev-parse HEAD`
4. Mettre à jour `rev` dans `extension.toml` (TOUJOURS le hash complet 40 caractères, jamais abrégé)
5. **Supprimer le dossier `grammars/`** dans zed-spip (cache WASM)
6. Redémarrer Zed

### Vérifier la coloration

Demander à l'utilisateur de fournir le JSON de coloration actuel (via les devtools Zed ou un script). Ce JSON montre exactement quel highlight est appliqué à chaque segment de texte.

## Pièges critiques et leçons apprises

### 1. FUITE MEMOIRE — highlights.scm : captures de nœuds composés

**REGLE N°1 : JAMAIS capturer un nœud composé entier dans highlights.scm.**

```scheme
; MAUVAIS — provoque une consommation mémoire infinie dans Zed
(loop_open) @keyword
(include_tag) @keyword.import
(multi_block) @string

; BON — capturer uniquement les tokens littéraux ou les champs
"<BOUCLE_" @keyword
(loop_open name: (loop_name) @keyword)
(loop_open ">" @keyword)
```

Les captures de nœuds composés (qui contiennent des enfants) causent un bug dans le moteur de highlight WASM de Zed qui entre dans une boucle infinie de consommation mémoire. Seules les captures suivantes sont sûres :
- **Tokens littéraux** : `"<BOUCLE_" @keyword`, `"#" @variable`
- **Captures de champs** : `(loop_open name: (loop_name) @keyword)`
- **Tokens littéraux dans un contexte** : `(loop_open ">" @keyword)`
- **Nœuds feuilles** (sans enfants) : `(comment) @comment`, `(conditional_open) @variable`

### 2. FUITE MEMOIRE — path_suffixes = ["html"]

**JAMAIS** mettre `path_suffixes = ["html"]` dans `config.toml`. Cela remplace complètement le parser HTML intégré de Zed et provoque une fuite mémoire. C'est une limitation connue de Zed (zed-industries/zed#8795).

Solution : garder `path_suffixes = ["spip"]` et utiliser `file_types` dans les settings du projet :
```json
{ "file_types": { "SPIP": ["html"] } }
```

### 3. colorize_brackets entre en conflit avec la coloration SPIP

Le feature `colorize_brackets` de Zed assigne des couleurs arc-en-ciel aux brackets (`[`, `]`, `(`, `)`, `{`, `}`), ce qui écrase les captures de highlights.scm. Il faut le désactiver pour SPIP :

```json
{
  "languages": {
    "SPIP": {
      "colorize_brackets": false
    }
  }
}
```

Sans ça, `[(#DATE)]` s'affiche avec 5 couleurs différentes au lieu d'être uniformément `@variable`.

### 4. rev dans extension.toml : TOUJOURS le hash complet

```toml
# MAUVAIS — Zed refuse d'installer l'extension
rev = "993c9f8"

# BON
rev = "993c9f8dabaeae5140fcd2e3741cb90859ddc62f"
```

### 5. Cache grammars/ — TOUJOURS supprimer après changement de rev

Zed cache le WASM compilé dans `grammars/spip.wasm`. Si on change le `rev` dans extension.toml sans supprimer ce cache, Zed utilise l'ancienne version compilée. Toujours faire :

```bash
rm -rf grammars/
```

puis redémarrer Zed.

### 6. Snippets : déclaration obligatoire dans extension.toml

Les snippets ne se chargent PAS automatiquement. Il faut déclarer :

```toml
snippets = "./snippets/spip.json"
```

Le nom du fichier (`spip.json`) doit correspondre au nom de grammaire en minuscules.

### 7. Emmet pour SPIP

Emmet ne fonctionne pas par défaut pour les langages personnalisés. L'extension Emmet de Zed a une **liste explicite de langages** dans son `extension.toml` (`~/Library/Application Support/Zed/extensions/installed/emmet/extension.toml`). Si un langage n'est pas dans cette liste, le language server n'est jamais démarré pour ce langage.

**La solution `includeLanguages` dans les settings Zed NE FONCTIONNE PAS** — Zed filtre les langages avant de démarrer le serveur. C'est une limitation connue (zed-industries/zed#16481).

**Solution** : le script `scripts/patch-emmet.sh` modifie le `extension.toml` d'Emmet pour y ajouter :
1. `"SPIP"` dans la liste `languages` de `[language_servers.emmet-language-server]`
2. `SPIP = "html"` dans `[language_servers.emmet-language-server.language_ids]`

En plus du patch, il faut `"language_servers": ["emmet-language-server", "..."]` dans les settings du projet pour que Zed associe le serveur au langage SPIP.

**Important** : le patch est écrasé à chaque mise à jour de l'extension Emmet. Relancer le script après chaque MAJ.

## Stratégie de coloration (highlights.scm)

### Palette de couleurs par construction

| Construction | Capture | Éléments concernés |
|---|---|---|
| Boucles | `@keyword` | `<BOUCLE_`, nom, `(`, `)`, `>`, `</BOUCLE_`, `<B_`, `</B_`, `<//B_`, `{`/`}` critères |
| Type de boucle | `@type` | `ARTICLES`, `RUBRIQUES`, etc. |
| Critères (valeur) | `@attribute` | contenu de `{...}` dans les boucles |
| Balises | `@variable` | `#`, `(#`, nom, `)`, `[`, `]`, `{`/`}` des params |
| Params balise (contenu) | `@attribute` | `toto.jpg` dans `{toto.jpg}` |
| Filtres | `@function.method` | nom du filtre, `{`/`}` des params filtre |
| Filtres spéciaux | `@function.builtin` | `oui`, `non` |
| Params filtre (contenu) | `@attribute` | `20` dans `{20}` |
| Pipe | `@punctuation.delimiter` | `\|` |
| Include | `@keyword.import` | `<INCLURE`, `/>`, `>`, `{`/`}` |
| Include params | `@string.special` | contenu des `{...}` |
| Multi | `@keyword` | `<multi>`, `</multi>` |
| Code langue | `@constant` | `[fr]`, `{en}` |
| Texte multi | `@string` | texte entre codes langue |
| Traductions | `@keyword` | `<:`, `:>` |
| Chaîne traduction | `@string.special.symbol` | `module:chaine` |
| Commentaires | `@comment` | `[(#REM) ... ]` |

### Principe clé : accolades de paramètres

Les `{`/`}` qui entourent les paramètres d'une balise sont colorés avec la **même couleur que la balise** (`@variable`), pas avec la couleur du contenu. Seul le contenu à l'intérieur est en `@attribute`. Cela reflète le fait que les accolades font syntaxiquement partie de la balise.

Pour les filtres, les `{`/`}` sont en `@function.method` (couleur du filtre), le contenu en `@attribute`.

### Shorthand vs parenthèses

Les balises existent sous deux formes qui utilisent des nœuds grammar différents :

- `(#CHEMIN{toto.jpg})` → `balise` + `balise_params` (le `{` est un littéral du grammar)
- `#CHEMIN{toto.jpg}` → `balise_shorthand` + `shorthand_params` (le `{` est le token externe `shorthand_lbrace`)

Les deux doivent avoir les mêmes captures de couleur. Le `shorthand_lbrace` est capturé par `(shorthand_lbrace) @variable`.

## Injection HTML

L'injection HTML (`injections.scm`) est **combinée** (`injection.combined`), ce qui fusionne tous les nœuds `content` disjoints en un seul document virtuel HTML. Cela permet au parser HTML de fonctionner correctement même quand le HTML est entrecoupé de constructions SPIP.

## Ajout d'une nouvelle fonctionnalité

1. **Modifier la grammaire** dans tree-sitter-spip (grammar.js, éventuellement scanner.c)
2. **Ajouter des tests** dans tree-sitter-spip/test/corpus/
3. **Générer et tester** : `npx tree-sitter generate && npx tree-sitter test`
4. **Committer et pousser** tree-sitter-spip
5. **Mettre à jour highlights.scm** dans zed-spip (en respectant la règle : pas de captures de nœuds composés)
6. **Mettre à jour extension.toml** avec le nouveau rev (hash complet)
7. **Supprimer grammars/** pour forcer la recompilation WASM
8. **Tester dans Zed** : redémarrer, ouvrir un fichier .spip ou .html (avec file_types configuré)
9. **Vérifier** via le JSON de highlight que les captures sont correctes
10. **Committer et pousser** zed-spip

## Config recommandée pour projets SPIP (.zed/settings.json)

```json
{
  "file_types": {
    "SPIP": ["html"]
  },
  "languages": {
    "SPIP": {
      "language_servers": ["emmet-language-server"],
      "colorize_brackets": false
    }
  },
  "lsp": {
    "emmet-language-server": {
      "settings": {
        "emmet": {
          "includeLanguages": {
            "spip": "html"
          }
        }
      }
    }
  }
}
```
