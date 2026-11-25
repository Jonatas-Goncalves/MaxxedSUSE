#!/bin/bash
# Compile gettext catalogs into .mo files under po/locale/.
set -e

cd "$(dirname "$0")"
mkdir -p locale

for po in *.po; do
	lang="${po%.po}"
	mkdir -p "locale/$lang/LC_MESSAGES"
	msgfmt --check -o "locale/$lang/LC_MESSAGES/maxxedsuse.mo" "$po"
	echo "Compiled $lang"
done
