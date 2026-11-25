#!/bin/bash

# MaxxedSUSE entry point for openSUSE Tumbleweed.

set -e

REPO_URL="https://github.com/Jonatas-Goncalves/MaxxedSUSE.git"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INSTALL_DIR="$HOME/MaxxedSUSE"
LOCAL_CHECKOUT=0

if [[ -f "$SCRIPT_DIR/src/maxxedsuseapp.py" && -f "$SCRIPT_DIR/catalog/apps.json" ]]; then
	INSTALL_DIR="$SCRIPT_DIR"
	LOCAL_CHECKOUT=1
fi

info() {
	printf '\033[1;32m%s\033[0m\n' "$1"
}

warn() {
	printf '\033[1;33m%s\033[0m\n' "$1"
}

create_desktop_launcher() {
	local desktop_dir desktop_file exec_line
	desktop_dir="${XDG_DATA_HOME:-$HOME/.local/share}/applications"
	desktop_file="$desktop_dir/maxxedsuse-user.desktop"
	mkdir -p "$desktop_dir"

	exec_line="env PYTHONPATH=\"$INSTALL_DIR/src\" MXX_DATADIR=\"$INSTALL_DIR\" MXX_LOCALEDIR=\"$INSTALL_DIR/po/locale\" python3 \"$INSTALL_DIR/src/maxxedsuseapp.py\""

	cat > "$desktop_file" <<EOF
[Desktop Entry]
# Created by MaxxedSUSE.sh
Type=Application
Name=MaxxedSUSE
GenericName=openSUSE Setup Utility
Comment=Configure openSUSE Tumbleweed and install applications
Exec=$exec_line
Icon=$INSTALL_DIR/data/maxxedsuse.svg
Terminal=false
Categories=System;
StartupNotify=true
EOF
	info "Desktop shortcut created in the System menu."
}

if ! grep -q '^ID="\?opensuse-tumbleweed' /etc/os-release 2>/dev/null; then
	warn "MaxxedSUSE supports openSUSE Tumbleweed only."
	exit 1
fi

info "MaxxedSUSE"

if (( LOCAL_CHECKOUT )); then
	info "Using the local checkout: $INSTALL_DIR"
else
	if ! rpm -q git >/dev/null 2>&1; then
		info "Installing git..."
		xdg-su -c "zypper --non-interactive install git" 2>/dev/null || {
			warn "Could not install git. Install it manually and run this script again."
			exit 1
		}
	fi

	if [[ -d "$INSTALL_DIR/.git" ]]; then
		info "Updating the local copy..."
		git -C "$INSTALL_DIR" fetch origin
		git -C "$INSTALL_DIR" pull --ff-only origin main
	else
		info "Downloading MaxxedSUSE..."
		git clone --single-branch --branch main "$REPO_URL" "$INSTALL_DIR"
	fi
fi

cd "$INSTALL_DIR"

missing=()
for pkg in python3 python3-gobject gtk4 libadwaita-1-0 typelib-1_0-Gtk-4_0 typelib-1_0-Adw-1; do
	rpm -q "$pkg" >/dev/null 2>&1 || missing+=("$pkg")
done

if (( ${#missing[@]} )); then
	info "Installing required components: ${missing[*]}"
	if ! xdg-su -c "zypper --non-interactive install ${missing[*]}" 2>/dev/null; then
		warn "Could not install the required components automatically."
		warn "Install them manually: sudo zypper install ${missing[*]}"
		exit 1
	fi
fi

if ! python3 -c 'import gi; gi.require_version("Gtk", "4.0"); gi.require_version("Adw", "1"); from gi.repository import Adw' 2>/dev/null; then
	warn "GTK4/libadwaita bindings are still unavailable to Python."
	exit 1
fi

if (( ! LOCAL_CHECKOUT )) && ! rpm -q maxxedsuse >/dev/null 2>&1; then
	create_desktop_launcher
fi

info "Starting MaxxedSUSE..."
export PYTHONPATH="$INSTALL_DIR/src${PYTHONPATH:+:$PYTHONPATH}"
export MXX_LOCALEDIR="$INSTALL_DIR/po/locale"
exec python3 "$INSTALL_DIR/src/maxxedsuseapp.py" "$@"
