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
		FALSE		'Chromium'			"Open-source browser project that aims to build a safer, faster, and more stable"\
		FALSE		'Cloudflare Warp'			"Connect to the Internet faster and in a more secure way"\
		FALSE 		'Deluge'			"Is a lightweight, Free Software, cross-platform BitTorrent client"\
		FALSE 		'Discord'			"All-in-one voice and text chat for Gamers"\
		FALSE 		'Epiphany'			"A simple, clean, beautiful view of the Web"\
		FALSE 		'Fragments'			"An easy to use BitTorrent client"\
		FALSE 		'Google Chrome' 	"A cross-platform web browser by Google"\
		FALSE 		'LibreWolf' 	"A privacy and security-focused browser"\
		FALSE 		'Mailspring'			"Mailspring is a new version of Nylas Mail"\
		FALSE		'Signal'		"Signal - Private Messenger: Say Hello to Privacy"\
		FALSE		'Skype'		"Call and message skype users, with video chat support"\
		FALSE		'Slack'		"Slack is a cloud-based team communication platform"\
		FALSE		'SyncThingTray'		"Tray application and Dolphin/Plasma integration for Syncthing"\
		FALSE		'Tangram'		"Browser designed to organize and run your Web applications"\
		FALSE		'Telegram Desktop'	"Official Desktop Client for the Telegram Messenger"\
		FALSE		'Tor Browser Launcher'	"A program to help you download, keep updated, and run the Tor Browser Bundle"\
		FALSE		'Warp'	"Fast and secure file transfer"\
		FALSE		'Webapp Manager'	"Run websites as if they were apps"\
		FALSE		'Whatsapp'			"An unofficial WhatsApp desktop application for Linux"\
		FALSE		'Valent'	"Connect, control and sync devices"\
		FALSE		'ZapZap'	"All features of the Whatpp Web are available and several others"\
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

			"Chromium")				#Open-source browser project that aims to build a safer, faster, and more stable
					ZYPPER_INSTALL "chromium" "Chromium" "chromium"
				;;

			"Cloudflare Warp")				#Connect to the Internet faster and in a more secure way
					ZYPPER_INSTALL "cloudflare_warp" "Cloudflare Warp" "cloudflare_warp"
				;;

			"Deluge")				#Is a lightweight, Free Software, cross-platform BitTorrent client
					ZYPPER_INSTALL "deluge" "Deluge" "deluge"
				;;

			"Discord")				#Discord
					ZYPPER_INSTALL "discord" "Discord" "discord"
				;;

			"Epiphany")				#A simple, clean, beautiful view of the Web
					ZYPPER_INSTALL "epiphany" "Epiphany" "epiphany"
				;;

			"Fragments")				#An easy to use BitTorrent client
					FLATPAK_INSTALL "de.haeckerfelix.Fragments" "Fragments" "de.haeckerfelix.Fragments"
				;;

			"Google Chrome")			#Google Chrome web browser
					Arch=$(GET_SYSTEM_ARCH)
					sudo zypper ar http://dl.google.com/linux/chrome/rpm/stable/$Arch Google-Chrome
					sudo rpm --import https://dl.google.com/linux/linux_signing_key.pub
					ZYPPER_REFRESH
					ZYPPER_INSTALL "google-chrome-stable" "Google Chrome" "google-chrome-stable"
				;;
				
			"LibreWolf")				#A privacy and security-focused browser
					ZYPPER_INSTALL "librewolf" "LibreWolf" "librewolf"
				;;

			"Mailspring")			#Mailspring Mail Client
					SNAP_INSTALL "mailspring" "Mailspring" "mailspring"
				;;

			"Signal")			#Signal - Private Messenger: Say Hello to Privacy
					ZYPPER_INSTALL "signal-desktop" "Signal" "signal-desktop"
				;;

			"Skype")			#Call and message skype users, with video chat support
					FLATPAK_INSTALL "com.skype.Client" "Skype" "com.skype.Client"
				;;

			"Slack")			#Slack is a cloud-based team communication platform
					FLATPAK_INSTALL "com.slack.Slack" "Slack" "com.slack.Slack"
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

			"Tor Browser Launcher")		#A program to help you download, keep updated, and run the Tor Browser Bundle
					ZYPPER_INSTALL "torbrowser-launcher" "Tor Browser Launcher" "torbrowser-launcher"
				;;

			"Warp")			#Fast and secure file transfer
					ZYPPER_INSTALL "Warp" "warp" "Warp"
				;;

			"Webapp Manager")			#Run websites as if they were apps
					ZYPPER_INSTALL "webapp-manager" "Webapp Manager" "webapp-manager"
				;;

			"Whatsapp")		#An unofficial WhatsApp desktop application for Linux
					ZYPPER_INSTALL "whatsapp-for-linux" "Whatsapp" "whatsapp-for-linux"
				;;

			"Valent")			#Connect, control and sync devices
					ZYPPER_INSTALL "valent" "Valent" "valent"
				;;

			"ZapZap")			#All features of the Whatpp Web are available and several others
					FLATPAK_INSTALL "com.rtosta.zapzap" "ZapZap" "com.rtosta.zapzap"
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
