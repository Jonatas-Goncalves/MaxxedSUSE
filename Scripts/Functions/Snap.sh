#!/bin/bash

SNAP_INSTALL() {
	software=$1
	Name=$2
	snaplisting=$3
	classicflag=$4
	
	#if already present, don't install
	if [[ "$snaplisting" == $(snap list | awk {'print $1'} | grep $snaplisting) ]]; then
						zenity --info --timeout 5 --window-icon="./Icons/Install/$snaplisting.png" \
						--text="\n$Name Already Installed\t\t"\
						--title "Installed" --no-wrap 2>/dev/null
	else
		sudo snap install $software $classicflag 2>&1 | \
		tee >( \
		zenity --progress --pulsate --width=720 --window-icon="./Icons/Install/$snaplisting.png"\
		--text="Downloading $Name..." --auto-kill --auto-close --no-cancel\
		2>/dev/null)
			
		#Installation Complete Dialog
		zenity --info --timeout 5\
		--text="\nInstallation Complete\t\t"\
		--title "$Name" --no-wrap --window-icon="./Icons/Install/$snaplisting.png" 2>/dev/null
	fi
}

					
					
