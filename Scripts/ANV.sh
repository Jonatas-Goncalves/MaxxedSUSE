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

#------------- AUDIO & VIDEO -------------#
	ANV=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		'Deezer'			"Deezer is a music streaming app"\
		FALSE		'Kdenlive'		"Free, Open-source, Non-Linear Video Editor by KDE"\
		FALSE		'gThumb'		    "Is an open-source software image viewer, image organizer"\
		FALSE		'Jellyfin'		    "Desktop client using jellyfin-web with embedded MPV player"\
		FALSE 		'OBS Studio'		"Capturing, compositing, recording, and streaming video content"\
		FALSE 		'Spotify'			"Spotify Music Player"\
		FALSE 		'Stremio'			"Watch videos, movies, TV series and TV channels instantly"\
		FALSE 		'VLC' 			"VLC Media Player" );
	
	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$ANV"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the names in "Software(s)" column, also IFS unset later
		IFS=$'\n'

		for option in $(echo $ANV | tr "|" "\n"); do

			case $option in

			"Deezer")			#Deezer is a music streaming app
					ZYPPER_INSTALL "deezer" "Deezer" "deezer"
				;;

			"Kdenlive")			#Free, Open-source, Non-Linear Video Editor by KDE
					ZYPPER_INSTALL "kdenlive" "Kdenlive" "kdenlive"
				;;

			"gThumb")			#Is an open-source software image viewer, image organizer
					ZYPPER_INSTALL "gthumb" "gThumb" "gthumb"
				;;

			"Jellyfin")			#Desktop client using jellyfin-web with embedded MPV player
					ZYPPER_INSTALL "jellyfin-media-playe" "Jellyfin" "jellyfin-media-playe"
				;;

			"OBS Studio")			#Capturing, compositing, recording, and streaming video content
					ZYPPER_INSTALL "obs-studio" "OBS Studio" "obs-studio"
				;;

			"Spotify")		#Spotify Music Player
					ZYPPER_INSTALL "spotify-client" "Spotify" "spotify-client"
				;;

			"Stremio")		#Watch videos, movies, TV series and TV channels instantly
					ZYPPER_INSTALL "stremio" "Stremio" "stremio"
				;;

			"VLC")			#VLC Media Player
					ZYPPER_INSTALL "vlc" "VLC" "vlc"
				;;
			esac
		done

		source ./Start.sh
	fi
	unset IFS
#----------------- AUDIO & VIDEO end ------------------#


	if [[ ! -z $ANV ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
