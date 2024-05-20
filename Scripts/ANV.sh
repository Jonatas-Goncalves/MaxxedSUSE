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

#------------- AUDIO AND VIDEO -------------#
	ANV=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		'Audacious' 		"Lightweight open source audio player descendant of XMMS"\
		FALSE 		'Audacity' 		"World's most popular audio editing and recording app"\
		FALSE 		'Boxy SVG' 		"Scalable Vector Graphics editor"\
		FALSE 		'Deezer' 		"Deezer is a music streaming app"\
		FALSE		'Kdenlive' 		"Free, Open-source, Non-Linear Video Editor by KDE"\
		FALSE		'GIMP' 		"Create images and edit photographs"\
		FALSE		'gThumb' 		"Is an open-source software image viewer, image organizer"\
		FALSE		'HandBrake' 		"Tool for converting video from nearly any format to a selection of modern"\
		FALSE		'Jellyfin' 		"Desktop client using jellyfin-web with embedded MPV player"\
		FALSE		'Jellyfin Server' 		"Media System Manager that puts you in control of managing and streaming your media."\
		FALSE		'Kodi' 		"Ultimate entertainment center"\
		FALSE		'Kooha' 		"Elegantly record your screen"\
		FALSE		'Krita' 		"Full-featured digital art studio"\
		FALSE		'Megacubo' 		"A intuitive, multi-language and cross-platform IPTV player"\
		FALSE		'Nomacs' 		"Free, open source image viewer"\
		FALSE 		'OBS Studio' 		"Capturing, compositing, recording, and streaming video content"\
		FALSE 		'Plex' 		"Plex client for desktop computers"\
		FALSE 		'Spotify' 		"Spotify Music Player"\
		FALSE 		'Stremio' 		"Watch videos, movies, TV series and TV channels instantly"\
		FALSE 		'Upscayl' 		"Free and Open Source AI Image Upscaler"\
		FALSE 		'VLC' 		"VLC Media Player"\
		FALSE 		'Youtube Downloader Plus' 		"Download videos and audios from hundreds of sites" );

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

			"Audacious")			#Lightweight open source audio player descendant of XMMS
					ZYPPER_INSTALL "audacious" "Audacious" "audacious"
				;;

			"Audacity")			#World's most popular audio editing and recording app
					ZYPPER_INSTALL "audacity" "Audacity" "audacity"
				;;

			"Boxy SVG")			#Scalable Vector Graphics editor
					FLATPAK_INSTALL "com.boxy_svg.BoxySVG" "Boxy SVG" "com.boxy_svg.BoxySVG"
				;;

			"Deezer")			#Deezer is a music streaming app
					ZYPPER_INSTALL "deezer" "Deezer" "deezer"
				;;

			"Kdenlive")			#Free, Open-source, Non-Linear Video Editor by KDE
					ZYPPER_INSTALL "kdenlive" "Kdenlive" "kdenlive"
				;;

			"GIMP")			#Create images and edit photographs
					ZYPPER_INSTALL "gimp" "GIMP" "gimp"
				;;

			"gThumb")			#Is an open-source software image viewer, image organizer
					ZYPPER_INSTALL "gthumb" "gThumb" "gthumb"
				;;

			"HandBrake")			#Tool for converting video from nearly any format to a selection of modern
					ZYPPER_INSTALL "handbrake-gtk" "HandBrake" "handbrake-gtk"
				;;

			"Jellyfin")			#Desktop client using jellyfin-web with embedded MPV player
					ZYPPER_INSTALL "jellyfin-media-playe" "Jellyfin" "jellyfin-media-playe"
				;;

			"Jellyfin Server")			#Free Software Media System that puts you in control of managing and streaming your media.
					FLATPAK_INSTALL "org.jellyfin.JellyfinServer" "Jellyfin Server" "org.jellyfin.JellyfinServer"
				;;

			"Kodi")			#Ultimate entertainment center
					ZYPPER_INSTALL "kodi" "Kodi" "kodi"
				;;

			"Kooha")			#Elegantly record your screen
					FLATPAK_INSTALL "io.github.seadve.Kooha" "Kooha" "io.github.seadve.Kooha"
				;;

			"Krita")			#Full-featured digital art studio
					ZYPPER_INSTALL "krita" "Krita" "krita"
				;;

			"Megacubo")			#A intuitive, multi-language and cross-platform IPTV player
					ZYPPER_INSTALL "megacubo" "Megacubo" "megacubo"
				;;

			"Nomacs")			#Free, open source image viewer
					ZYPPER_INSTALL "nomacs" "Nomacs" "nomacs"
				;;

			"OBS Studio")			#Capturing, compositing, recording, and streaming video content
					ZYPPER_INSTALL "obs-studio" "OBS Studio" "obs-studio"
				;;

			"Plex")		#Plex client for desktop computers
					FLATPAK_INSTALL "tv.plex.PlexDesktop" "Plex" "tv.plex.PlexDesktop"
				;;

			"Spotify")		#Spotify Music Player
					ZYPPER_INSTALL "spotify-client" "Spotify" "spotify-client"
				;;

			"Stremio")		#Watch videos, movies, TV series and TV channels instantly
					ZYPPER_INSTALL "stremio" "Stremio" "stremio"
				;;

			"Upscayl")		#Free and Open Source AI Image Upscaler
					FLATPAK_INSTALL "org.upscayl.Upscayl" "Upscayl" "org.upscayl.Upscayl"
				;;

			"VLC")			#VLC Media Player
					ZYPPER_INSTALL "vlc" "VLC" "vlc"
				;;

			"Youtube Downloader Plus")			#Download videos and audios from hundreds of sites
					FLATPAK_INSTALL "io.github.aandrew_me.ytdn" "Youtube Downloader Plus" "io.github.aandrew_me.ytdn"
				;;

			esac
		done

		source ./Start.sh
	fi
	unset IFS
#----------------- AUDIO AND VIDEO end ------------------#


	if [[ ! -z $ANV ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
