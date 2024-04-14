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

#--------- COMMUNICATION & BROWSERS ----------#
	CNB=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE		'Brave'			"Secure, Fast & Private Brave Browser with Adblocker"\
		FALSE		'Cloudflare Warp'			"Connect to the Internet faster and in a more secure way"\
		FALSE 		'Discord'			"All-in-one voice and text chat for Gamers"\
		FALSE 		'Epiphany'			"A simple, clean, beautiful view of the Web."\
		FALSE 		'Google Chrome' 	"A cross-platform web browser by Google"\
		FALSE 		'Mailspring'			"Mailspring is a new version of Nylas Mail"\
		FALSE		'Signal'		"Signal - Private Messenger: Say Hello to Privacy"\
		FALSE		'SyncThingTray'		"Tray application and Dolphin/Plasma integration for Syncthing"\
		FALSE		'Tangram'		"Browser designed to organize and run your Web applications"\
		FALSE		'Telegram Desktop'	"Official Desktop Client for the Telegram Messenger"\
		FALSE		'Warp'	"Fast and secure file transfer"\
		FALSE		'Whatsapp'			"An unofficial WhatsApp desktop application for Linux"\
		FALSE		'Valent'	"Connect, control and sync devices"\
		FALSE		'ZeroTier One'			"A Smart Ethernet Switch for Earth" );
	
	
	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$CNB"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $CNB | tr "|" "\n"); do

			case $option in
			
			"Brave")				#Brave Browser
					sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
					sudo zypper ar https://brave-browser-rpm-release.s3.brave.com/brave-browser.repo
					ZYPPER_REFRESH
					ZYPPER_INSTALL "brave-browser" "Brave" "brave-browser"
				;;

			"Cloudflare Warp")				#Connect to the Internet faster and in a more secure way
					ZYPPER_INSTALL "cloudflare_warp" "Cloudflare Warp" "cloudflare_warp"
				;;

			"Discord")				#Discord
					ZYPPER_INSTALL "discord" "Discord" "discord"
				;;

			"Epiphany")				#A simple, clean, beautiful view of the Web.
					ZYPPER_INSTALL "epiphany" "Epiphany" "epiphany"
				;;

			"Google Chrome")			#Google Chrome web browser
					Arch=$(GET_SYSTEM_ARCH)
					sudo zypper ar http://dl.google.com/linux/chrome/rpm/stable/$Arch Google-Chrome
					sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
					ZYPPER_REFRESH
					ZYPPER_INSTALL "google-chrome-stable" "Google Chrome" "google-chrome-stable"
				;;
				
			"Mailspring")			#Mailspring Mail Client
					SNAP_INSTALL "mailspring" "Mailspring" "mailspring"
				;;

			"Signal")			#Signal - Private Messenger: Say Hello to Privacy
					ZYPPER_INSTALL "signal-desktop" "Signal" "signal-desktop"
				;;

			"SyncThingTray")			#Tray application and Dolphin/Plasma integration for Syncthing
					ZYPPER_INSTALL "syncthingtray" "SyncThingTray" "syncthingtray"
				;;

			"Tangram")			#Browser designed to organize and run your Web applications
					ZYPPER_INSTALL "tangram" "Tangram" "tangram"
				;;

			"Telegram Desktop")		#Official Desktop Client for the Telegram Messenger
					ZYPPER_INSTALL "telegram-desktop" "Telegram Desktop" "telegram-desktop"
				;;

			"Warp")			#Fast and secure file transfer
					ZYPPER_INSTALL "Warp" "warp" "Warp"
				;;

			"Whatsapp")		#An unofficial WhatsApp desktop application for Linux
					ZYPPER_INSTALL "whatsapp-for-linux" "Whatsapp" "whatsapp-for-linux"
				;;

			"Valent")			#Connect, control and sync devices
					ZYPPER_INSTALL "valent" "Valent" "valent"
				;;

			"ZeroTier One")		#An unofficial WhatsApp desktop application for Linux
					ZYPPER_INSTALL "zerotier-one" "ZeroTier One" "zerotier-one"
				;;
			esac
		done

		source ./Start.sh
	fi
	unset IFS
#------------ COMMUNICATION & BROWSERS end ------------#


	if [[ ! -z $CNB ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
