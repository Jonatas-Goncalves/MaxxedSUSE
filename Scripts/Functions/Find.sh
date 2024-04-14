#!/bin/bash



FIND() {
    Path="$1"
    Sh="$2"

    Fullpath="$(dirname "${0}")/${Path}/${Sh}"

    # Remove extra slashes in the path
    Fullpath=$(echo "$Fullpath" | sed 's#//*#/#g')

    if [ -f "$Fullpath" ]; then
        source "$Fullpath"
    else
        zenity --error --title="File Not Found" \
        2>/dev/null --no-wrap \
        --text="\nCannot locate File: $Fullpath"
    fi
}
