# SPIP for Zed

Extension [Zed](https://zed.dev/) pour le langage de squelettes [SPIP](https://www.spip.net/).

## Fonctionnalites

- **Coloration syntaxique** de toutes les constructions SPIP (boucles, balises, filtres, inclusions, commentaires, multi, traductions)
- **Injection HTML** : le HTML entre les constructions SPIP est correctement colorise
- **150+ snippets/completions** : balises SPIP, filtres, criteres de boucles, API PHP SPIP
- **Indentation automatique** dans les boucles
- **Bracket matching** pour les boucles, crochets conditionnels, et parametres
- **Outline** : les boucles et inclusions apparaissent dans le panneau outline

## Installation

### Depuis le registre Zed

1. Ouvrir Zed
2. `Cmd+Shift+P` > "Extensions: Install Extension"
3. Chercher "SPIP"
4. Installer

### Installation en mode dev

```bash
git clone https://github.com/MathieuAlphamosa/zed-spip.git
```

Dans Zed : `Cmd+Shift+P` > "Extensions: Install Dev Extension" > selectionner le dossier `zed-spip/`.

## Detection des fichiers

SPIP utilise des fichiers `.html` pour ses squelettes. L'extension ne peut pas revendiquer directement les fichiers `.html` car cela remplacerait completement le parser HTML integre de Zed (limitation connue : les extensions Zed ne peuvent pas heriter ou etendre un langage integre, elles le remplacent entierement — voir [zed-industries/zed#8795](https://github.com/zed-industries/zed/issues/8795)).

Il est donc necessaire de configurer Zed pour associer les fichiers `.html` au langage SPIP dans vos projets SPIP.

> **Note importante** : ne pas ajouter `path_suffixes = ["html"]` dans la configuration de l'extension. Cela provoque un conflit avec le parser HTML integre de Zed et entraine une consommation memoire illimitee (fuite memoire).

### Configuration par projet (recommande)

Creez un fichier `.zed/settings.json` a la racine de votre projet SPIP :

```json
{
  "file_types": {
    "SPIP": ["html"]
  }
}
```

Cela indique a Zed d'utiliser le parser SPIP pour les fichiers `.html` dans ce projet, sans affecter les autres projets.

### Selection manuelle

Vous pouvez aussi selectionner le langage SPIP manuellement via le selecteur de langage en bas a droite de la fenetre Zed (cliquer sur "HTML" puis choisir "SPIP").

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

Cette extension et sa grammaire tree-sitter ont ete vibecodees avec [Claude Code](https://claude.ai/), l'agent IA de code d'Anthropic, a partir d'une [extension Sublime Text](https://github.com/MathieuAlphamosa/Sublime-SPIP-AM) existante. La grammaire, le scanner externe, le corpus de test et les 170+ snippets ont ete concus et iteres par conversation, testes sur 15 vrais squelettes SPIP de sites en production.

## License

MIT
