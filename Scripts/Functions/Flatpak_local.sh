#!/bin/bash

FLATPAK_LOCAL_INSTALL() {
    software=$1
    Name=$2
    flatpak_listing=$3

    # Checks if the application is already installed
    if flatpak list --app $flatpak_listing >/dev/null 2>&1; then
        zenity --info --timeout 5 --text="\n$Name Already Installed\t\t" \
        --title "Installed" --no-wrap 2>/dev/null
    else
        sudo flatpak install $software -y >/dev/null 2>&1 | \
        tee >( \
        zenity --progress --pulsate --width=720 \
        --text="Downloading $Name..." --auto-kill --auto-close --no-cancel \
        2>/dev/null)

        # Complete Installation Dialog
        zenity --info --timeout 5 --text="\nInstallation Complete\t\t" \
        --title "$Name" --no-wrap 2>/dev/null
    fi
}



