# SPIP for Zed

Extension [Zed](https://zed.dev/) pour le langage de squelettes [SPIP](https://www.spip.net/).

<img width="1315" height="869" alt="Capture d’écran 2026-02-22 à 19 09 40" src="https://github.com/user-attachments/assets/64a7cbfb-74b3-462c-ad99-d693222545fb" />


## Fonctionnalites

- **Coloration syntaxique** de toutes les constructions SPIP (boucles, balises, filtres, inclusions, commentaires, multi, traductions)
- **Injection HTML** : le HTML entre les constructions SPIP est correctement colorise
- **150+ snippets/completions** : balises SPIP, filtres, criteres de boucles, API PHP SPIP
- **Indentation automatique** dans les boucles
- **Bracket matching** pour les boucles, crochets conditionnels, et parametres
- **Outline** : les boucles et inclusions apparaissent dans le panneau outline

## Installation

### Depuis le registre Zed

Indisponible pour le moment : je n'ai pas publié l'extension dans le registre Zed.

### Installation en mode dev

```bash
git clone https://github.com/MathieuAlphamosa/zed-spip.git
```

Dans Zed : `Cmd+Shift+P` > "Extensions: Install Dev Extension" > selectionner le dossier `zed-spip/`.

## Detection des fichiers

SPIP utilise des fichiers `.html` pour ses squelettes. L'extension ne peut pas revendiquer directement les fichiers `.html` car cela remplacerait completement le parser HTML integre de Zed (limitation connue : les extensions Zed ne peuvent pas heriter ou etendre un langage integre, elles le remplacent entierement — voir [zed-industries/zed#8795](https://github.com/zed-industries/zed/issues/8795)).

Il est donc necessaire de configurer Zed pour associer les fichiers `.html` au langage SPIP dans vos projets SPIP.

> **Note importante** : ne pas ajouter `path_suffixes = ["html"]` dans la configuration de l'extension. Cela provoque un conflit avec le parser HTML integre de Zed et entraine une consommation memoire illimitee (fuite memoire).

### Configuration par projet (recommandé)

Creez un fichier `.zed/settings.json` a la racine de votre projet SPIP :

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
  }
}
```

Cela indique a Zed d'utiliser le parser SPIP pour les fichiers `.html` dans ce projet, sans affecter les autres projets.

- `language_servers` active Emmet pour les fichiers SPIP (nécessite l'extension [Emmet](https://zed.dev/extensions/emmet) et le patch ci-dessous)
- `colorize_brackets` desactive la colorisation automatique des brackets, qui entre en conflit avec la coloration SPIP (les `[`, `]`, `(`, `)` des balises SPIP doivent garder la couleur de la balise, pas celle du bracket colorizer)

### Activer Emmet pour SPIP

L'extension Emmet de Zed ne supporte pas les langages tiers par defaut. Un script est fourni pour ajouter SPIP a la liste des langages supportes par Emmet :

```bash
./scripts/patch-emmet.sh
```

> **Note** : ce patch modifie le fichier `extension.toml` de l'extension Emmet installee localement (`~/Library/Application Support/Zed/extensions/installed/emmet/extension.toml`). Il est ecrase a chaque mise a jour de l'extension Emmet — relancez le script apres chaque mise a jour.

### Sélection manuelle

Vous pouvez aussi sélectionner le langage SPIP manuellement via le sélecteur de langage en bas a droite de la fenêtre Zed (cliquer sur "HTML" puis choisir "SPIP").

## Snippets disponibles

### Structures

| Prefixe | Description |
|---------|-------------|
| `boucle` | Boucle simple |
| `bouclec` | Boucle complete avec conditionnelles |
| `inclure` | Inclusion dynamique |
| `rem` | Commentaire SPIP |
| `img` | Balise img avec logo |
| `logo` | Logo avec traitements d'image |

### Balises SPIP (80+)

`#TITRE`, `#TEXTE`, `#CHAPO`, `#DESCRIPTIF`, `#ENV{...}`, `#SET{...}`, `#GET{...}`, `#URL_ARTICLE`, `#LOGO_ARTICLE`, `#PAGINATION`, etc.

### Filtres SPIP (70+)

`|couper`, `|image_reduire`, `|attribut_html`, `|extraire_attribut`, `|inserer_attribut`, `|propre`, `|textebrut`, `|oui`, `|non`, `|sinon`, etc.

### API PHP SPIP (30+)

`sql_select`, `sql_fetsel`, `recuperer_fond`, `include_spip`, `generer_url_ecrire`, `spip_log`, etc.

### Criteres de boucle

`{pagination}`, `{par ...}`, `{inverse}`, `{tout}`, `{origine_traduction}`

## Grammaire

Cette extension utilise la grammaire [tree-sitter-spip](https://github.com/MathieuAlphamosa/tree-sitter-spip).

## Genesis

Cette extension et sa grammaire tree-sitter ont été vibecodées avec [Claude Code](https://claude.ai/), l'agent IA de code d'Anthropic, à partir d'une [extension Sublime Text](https://github.com/MathieuAlphamosa/Sublime-SPIP-AM) existante. La grammaire, le scanner externe, le corpus de test et les 170+ snippets ont été concus et itérés par conversation.

## License

MIT
