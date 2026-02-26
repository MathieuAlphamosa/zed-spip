#!/usr/bin/env bash
#
# patch-emmet.sh — Ajoute le support SPIP à l'extension Emmet de Zed.
#
# À relancer après chaque mise à jour de l'extension Emmet dans Zed.
#
# Usage :
#   ./scripts/patch-emmet.sh
#

set -euo pipefail

EMMET_TOML="$HOME/Library/Application Support/Zed/extensions/installed/emmet/extension.toml"

if [ ! -f "$EMMET_TOML" ]; then
  echo "Erreur : extension Emmet non trouvée."
  echo "Installez l'extension Emmet dans Zed puis relancez ce script."
  exit 1
fi

# Vérifie si SPIP est déjà présent dans la section language_servers
if grep -q 'SPIP = "html"' "$EMMET_TOML"; then
  echo "SPIP est déjà configuré dans l'extension Emmet."
  exit 0
fi

# Patch le fichier avec awk :
# 1. Ajoute "SPIP" à la fin de la liste languages dans [language_servers.emmet-language-server]
# 2. Ajoute SPIP = "html" dans [language_servers.emmet-language-server.language_ids]
awk '
  # Détecte la section [language_servers.emmet-language-server]
  /^\[language_servers\.emmet-language-server\]/ { in_ls = 1 }

  # Dans cette section, patche la ligne languages = [...]
  in_ls && /^languages = \[/ && !/SPIP/ {
    sub(/\]/, ", \"SPIP\"]")
    in_ls = 0
  }

  # Détecte la section language_ids
  /^\[language_servers\.emmet-language-server\.language_ids\]/ { in_ids = 1 }

  # Insère SPIP = "html" avant la prochaine section vide ou [section]
  in_ids && /^$/ && !spip_added {
    print "SPIP = \"html\""
    spip_added = 1
  }

  { print }
' "$EMMET_TOML" > "$EMMET_TOML.tmp" && mv "$EMMET_TOML.tmp" "$EMMET_TOML"

# Vérification
if grep -q 'SPIP = "html"' "$EMMET_TOML"; then
  echo "Extension Emmet patchée avec succès pour SPIP."
  echo "Redémarrez Zed pour appliquer les changements."
else
  echo "Erreur : le patch a échoué. Vérifiez le fichier manuellement :"
  echo "  $EMMET_TOML"
  exit 1
fi
