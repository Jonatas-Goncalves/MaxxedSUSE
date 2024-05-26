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

#------------- GAMES STORES -------------#
	GST=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		HeroicGamesLauncher 		"Open Source Game Launcher for Epic and GOG"\
		FALSE 		Itch.io 		"Is a simple way to find, download and distribute indie games online"\
		FALSE 		Lutris 		"Play all your games on Linux"\
		FALSE 		PlayOnLinux 		"Install and use non-native applications on your favorite operating system"\
		FALSE 		RetroPlus 		"A simple ROM downloader"\
		FALSE 		Steam 		"Is a digital game distribution platform for computers"\
		FALSE 		Lutris-Flatpak 		"Flatpak version of Lutris"\
		FALSE 		Steam-Flatpack 		"Flatpak version of Steam" );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$GST"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the names in "Software(s)" column, also IFS unset later
		IFS=$'\n'

		for option in $(echo $GST | tr "|" "\n"); do

			case $option in

			"HeroicGamesLauncher")		#Open Source Game Launcher for Epic and GOG
					ZYPPER_INSTALL "HeroicGamesLauncher" "HeroicGamesLauncher" "HeroicGamesLauncher"
				;;

			"Itch.io")		#Is a simple way to find, download and distribute indie games online
					sudo wget --user-agent=Linux -E -c -t 3 -O /tmp/itch-setup https://itch.io/app/download
					sudo chmod +x /tmp/itch-setup && /tmp/./itch-setup
					sudo mv ~/.itch /opt/itch
					sudo mv ~/.local/share/applications/io.itch.itch.desktop /usr/share/applications/io.itch.itch.desktop
					sudo sed -i '4 c TryExec=/opt/itch/itch' /usr/share/applications/io.itch.itch.desktop
					sudo sed -i '5 c Exec=/opt/itch/itch --no-sandbox %U' /usr/share/applications/io.itch.itch.desktop
					sudo sed -i '6 c Icon=/opt/itch/icon.png' /usr/share/applications/io.itch.itch.desktop
					sudo sed -i '2 c /opt/itch/app-25.6.2/itch --no-sandbox --prefer-launch --appname itch -- "$@"' /opt/itch/itch
					sleep 10
				;;

			"Lutris")		#Play all your games on Linux
					ZYPPER_INSTALL "lutris" "Lutris" "lutris"
				;;

			"PlayOnLinux")		#Install and use non-native applications on your favorite operating system
					ZYPPER_INSTALL "PlayOnLinux" "PlayOnLinux" "PlayOnLinux"
				;;

			"RetroPlus")		#A simple ROM downloader
					FLATPAK_INSTALL "com.vysp3r.RetroPlus" "RetroPlus" "com.vysp3r.RetroPlus"
				;;

			"Steam")		#Is a digital game distribution platform for computers
					ZYPPER_INSTALL "steam" "Steam" "steam"
				;;

			"Lutris-Flatpak")		#Flatpak version of Lutris
					FLATPAK_INSTALL "net.lutris.Lutris" "Lutris-Flatpak" "net.lutris.Lutris"
				;;

			"Steam-Flatpak")		#Flatpak version of Steam
					FLATPAK_INSTALL "com.valvesoftware.Steam" "Steam-Flatpak" "com.valvesoftware.Steam"
					ZYPPER_INSTALL "steam-devices"
				;;

			esac
		done

		source ./Start.sh
	fi
	unset IFS
#----------------- GAMES STORES end ------------------#

	if [[ ! -z $GST ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
