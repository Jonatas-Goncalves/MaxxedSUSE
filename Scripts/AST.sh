#!/bin/bash

#Inclusion of Essential Scripts
source ./Scripts/Functions/Find.sh
FIND /Scripts/Functions/ Functions.sh
FIND /Scripts/Functions/ Snap.sh
FIND /Scripts/Functions/ Flatpak.sh
FIND /Scripts/Functions/ Flatpak_local.sh
FIND /Scripts/Functions/ Zypper.sh

# check if zenity is installed
CHECK_DEPENDS_ELSE_INSTALL

# run only if a superuser
if [[ $EUID -ne 0 ]]; then
	IF_NOT_SUPERUSER $(basename "$0")
   	exit 1
else
#if all permissions granted

#--------- ADVANCED SYSTEM TOOLS ----------#
	AST=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		'Android Studio'	"Android Studio IDE for Android"\
		FALSE		'Bottles'			"Easily manage wineprefix using environments"\
		FALSE		'Dockur'			"Windows in a Docker container."\
		FALSE 		'EnvyControl' 		"Easy way to switch between GPU modes on Nvidia Optimus systems"\
		FALSE		'Gnome Disk' 		"View, modify and configure disks and media"\
		FALSE		'Gparted' 		"Free partition editor for graphically managing your disk partitions"\
		FALSE		'GreenWithEnvy' 		"Control the fans and overclock your NVIDIA video card"\
		FALSE		'Imagewriter' 		"A powerful OS image that copies images to drives byte by byte"\
		FALSE		'OPI' 		"OBS Package Installer is a tool that finds and installs packages for openSUSE in OBS or Packman"\
		FALSE		'Signal'		"Signal - Private Messenger: Say Hello to Privacy"\
		FALSE		'SyncThingTray'		"Tray application and Dolphin/Plasma integration for Syncthing"\
		FALSE		'Telegram Desktop'	"Official Desktop Client for the Telegram Messenger"\
		FALSE		'Timeshift' 		"System snapshots backup and restore tool for Linux"\
		FALSE		'VSCodium' 		"VSCodium is a community-driven, freely distribution of Microsoft's editor VS Code"\
		FALSE		'WoeUSB-NG' 		"Utility that enables you to create your own bootable Windows USB"\
		FALSE		'Wake On Lan ' 		"The Wake On Lan client wakes up magic packet "\
		FALSE		'xsensors'			"GUI program that allows you to read useful data from the lm_sensors" );


	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$AST"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $AST | tr "|" "\n"); do

			case $option in

			"Android Studio")		#Android Studio IDE
					ZYPPER_INSTALL "android-studio" "Android Studio" "android-studio"
				;;

			"Bottles")				#Easily manage wineprefix using environments
					ZYPPER_INSTALL "Bottles" "Bottles" "Bottles"
				;;

			"EnvyControl")		#Easy way to switch between GPU modes on Nvidia Optimus systems
					ZYPPER_INSTALL "EnvyControl" "EnvyControl" "EnvyControl"
				;;

			"Gnome Disk")			#View, modify and configure disks and media
					ZYPPER_INSTALL "gnome-disk-utility" "Gnome Disk" "gnome-disk-utility"
				;;

			"Gparted")			#Is a free partition editor for graphically managing your disk partitions
					ZYPPER_INSTALL "gparted" "Gparted" "gparted"
				;;

			"GreenWithEnvy")			#Control the fans and overclock your NVIDIA video card
					ZYPPER_INSTALL "gwe" "GreenWithEnvy" "gwe"
				;;

			"Imagewriter")			#Open source Electron-based GitHub app
					ZYPPER_INSTALL "imagewriter" "Imagewriter" "imagewriter"
				;;

			"OPI")			#OBS Package Installer is a tool that finds and installs packages for openSUSE and SLE found in OBS or Packman
					ZYPPER_INSTALL "opi" "OPI" "opi"
				;;

			"Timeshift")			#System snapshots backup and restore tool for Linux
					ZYPPER_INSTALL "timeshift" "Timeshift" "timeshift"
				;;

			"VSCodium")			#VSCodium is a community-driven, freely-licensed binary distribution of Microsoft's editor VS Code
					Arch=$(GET_SYSTEM_ARCH)
					RPM_VSCODIUM=/tmp/Vscodium.rpm
					curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | grep browser_download_url | grep $Arch[.]rpm | head -n 1 | cut -d '"' -f 4 | sudo wget --base=http://github.com/ -i - -O /tmp/Vscodium.rpm
                    sudo zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys install --allow-unsigned-rpm --auto-agree-with-licenses /tmp/Vscodium.rpm
				;;

			"WoeUSB-NG")		#Utility that enables you to create your own bootable Windows USB
					ZYPPER_INSTALL "WoeUSB" "WoeUSB" "WoeUSB"
				;;

			"Wake On Lan")		#The Wake On Lan client wakes up magic packet
					ZYPPER_INSTALL "wol" "Wake On La" "wol"
				;;

			"xsensors")		#GUI program that allows you to read useful data from the lm_sensors
					ZYPPER_INSTALL "xsensors" "xsensors" "xsensors"
				;;
			esac
		done

		source ./Start.sh
	fi
	unset IFS
#------------ ADVANCED SYSTEM TOOLS end ------------#


	if [[ ! -z $AST ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
