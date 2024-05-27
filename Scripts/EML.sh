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

#------------- EMULATORS -------------#
	EML=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		EmulationStation 		"A cross-platform graphical front-end for emulators"\
		FALSE		Cartridges 		"Cartridges is an easy-to-use, elegant game launcher"\
		FALSE		Citra 		"Nintendo 3DS emulator"\
		FALSE 		Duckstation 		"Sony PlayStation(TM) Emulator"\
		FALSE 		Mame 		"Multiple Arcade Machine Emulator"\
		FALSE 		Mednafen 		"NES, FDS, Game Boy (Color|Advance), Super Nintendo, Virtual Boy"\
		FALSE 		Mupen64plus 		"Plugin-Based Nintendo 64 Emulator"\
		FALSE 		Nestopia 		"Nintendo Entertainment System/Famicom emulator"\
		FALSE 		PCSX2 		"Sony PlayStation 2 Emulator"\
		FALSE 		PCSXR 		"Free Sony PlayStation emulator with PGXP"\
		FALSE 		Pegasus-Frontend 		"Graphical frontend for launching emulators and managing your game collection"\
		FALSE 		PPSSPP 		"PlayStation Portable Emulator"\
		FALSE 		RetroArch 		"Frontend for emulators, game engines and media players"\
		FALSE 		RetroPlus 		"A simple ROM downloader"\
		FALSE 		RPCS3 		"PlayStation 3 emulator/debugger"\
		FALSE 		SNES9X 		"Portable, freeware Super Nintendo Entertainment System (TM) emulator"\
		FALSE 		Steam ROM Manager 		"An app for managing ROMs in Steam"\
		FALSE 		Xemu 		"Xbox Classic EMUlator"\
		FALSE 		Xenia 		"Xbox 360 emulator" );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$EML"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the names in "Software(s)" column, also IFS unset later
		IFS=$'\n'

		for option in $(echo $EML | tr "|" "\n"); do

			case $option in

			"EmulationStation")			#A cross-platform graphical front-end for emulators
					ZYPPER_INSTALL "EmulationStation" "EmulationStation" "EmulationStation"
				;;

			"Cartridges")			#Cartridges is an easy-to-use, elegant game launcher
					ZYPPER_INSTALL "cartridges" "Cartridges" "cartridges"
				;;

			"Citra")			#Nintendo 3DS emulator
					ZYPPER_INSTALL "citra" "Citra" "citra"
				;;

			"Duckstation")			#Sony PlayStation(TM) Emulator
					ZYPPER_INSTALL "duckstation" "Duckstation" "duckstation"
				;;

			"Mame")		#Multiple Arcade Machine Emulator
					ZYPPER_INSTALL "mame" "Mame" "mame"
				;;

			"Mednafen")		#NES, FDS, Game Boy (Color|Advance), Super Nintendo, Virtual Boy
					ZYPPER_INSTALL "mednafen" "Mednafen" "mednafen"
				;;

			"Mupen64plus")		#Plugin-Based Nintendo 64 Emulator
					ZYPPER_INSTALL "mupen64plus" "Mupen64plus" "mupen64plus"
				;;

			"Nestopia")		#Nintendo Entertainment System/Famicom emulator
					ZYPPER_INSTALL "nestopia" "Nestopia" "nestopia"
				;;

			"PCSX2")		#Sony PlayStation 2 Emulator
					ZYPPER_INSTALL "pcsx2-git" "PCSX2" "pcsx2-git"
				;;

			"PCSXR")		#Free Sony PlayStation emulator with PGXP
					ZYPPER_INSTALL "pcsxr" "PCSXR" "pcsxr"
				;;

			"Pegasus-Frontend")		#Graphical frontend for launching emulators and managing your game collection
					ZYPPER_INSTALL "pegasus-frontend" "Pegasus-Frontend" "pegasus-frontend"
				;;

			"PPSSPP")		#PlayStation Portable Emulator
					ZYPPER_INSTALL "ppsspp" "PPSSPP" "ppsspp"
				;;

			"RetroArch")		#Frontend for emulators, game engines and media players
					ZYPPER_INSTALL "retroarch" "RetroArch" "retroarch"
				;;

			"RetroPlus")		#A simple ROM downloader
					ZYPPER_INSTALL "RetroPlus" "RetroPlus" "RetroPlus"
				;;

			"RPCS3")		#GPlayStation 3 emulator/debugger
					ZYPPER_INSTALL "rpcs3" "RPCS3" "rpcs3"
				;;

			"SNES9X")		#Portable, freeware Super Nintendo Entertainment System (TM) emulator
					ZYPPER_INSTALL "snes9x" "SNES9X" "snes9x"
				;;

			"Steam ROM Manager")		#An app for managing ROMs in Steam
					FLATPAK_INSTALL "com.steamgriddb.steam-rom-manager" "Steam ROM Manager" "com.steamgriddb.steam-rom-manager"
				;;

			"Xemu")		#Xbox Classic EMUlator
					ZYPPER_INSTALL "xemu" "Xemu" "xemu"
				;;

			"Xenia")		#Xbox 360 emulator
					ZYPPER_INSTALL "xenia" "Xenia" "xenia"
				;;

			esac
		done

		source ./Start.sh
	fi
	unset IFS
#----------------- EMULATORS end ------------------#

	if [[ ! -z $EML ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
