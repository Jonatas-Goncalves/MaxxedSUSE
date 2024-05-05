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

#--------- WORK AND STUDIES ----------#
	WNS=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE		'Dialect'			"A translation app for GNOME"\
		FALSE		'Foliate'			"A simple and modern GTK eBook reader"\
		FALSE		'JPEG2PDF'			"Convert Images Into PDF File"\
		FALSE		'Normcap'			"Capture text from any screen area"\
		FALSE		'Obsidian'			"Markdown-based knowledge base"\
		FALSE		'OnlyOffice'		"Create, view and edit text documents, spreadsheets and presentations of any size and complexity"\
		FALSE		'PDF4QT'		"Free Open Source PDF Editor"\
		FALSE		'Planify'		"Forget about forgetting things"\
		FALSE		'Pomodoro'		"Pomodoro is a timer utility with rules, ideal for better productivity"\
		FALSE		'SpeechNote'		"Reading and translating with offline Speech to Text, Text to Speech and Machine Translation"\
		FALSE		'Teams-For-Linux'		"Unofficial Microsoft Teams client for Linux using Electron"\
		FALSE		'Thunderbird'		"Free and open source email, newsfeed, chat, and calendaring client"\
		FALSE		'WPS-OFFICE'			"Is a powerful office suite including Writer, Presentation and Spreadsheets" );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$WNS"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $WNS | tr "|" "\n"); do

			case $option in
			
			"Dialect")				#A translation app for GNOME
					ZYPPER_INSTALL "dialect" "Dialect" "dialect"
				;;

			"Foliate")				#A simple and modern GTK eBook reader
					ZYPPER_INSTALL "foliate" "Foliate" "foliate"
				;;

			"JPEG2PDF")				#Convert Images Into PDF File
					FLATPAK_INSTALL "com.warlordsoftwares.jpeg2pdf" "JPEG2PDF" "com.warlordsoftwares.jpeg2pdf"
				;;

			"Normcap")				#Capture text from any screen area
					ZYPPER_INSTALL "normcap" "Normcap" "normcap"
				;;

			"Obsidian")				#Markdown-based knowledge base
					FLATPAK_INSTALL "md.obsidian.Obsidian" "Obsidian" "md.obsidian.Obsidian"
				;;

			"OnlyOffice")			#Create, view and edit text documents, spreadsheets and presentations of any size and complexity
					ZYPPER_INSTALL "onlyoffice-desktopeditors" "OnlyOffice" "onlyoffice-desktopeditors"
				;;

			"PDF4QT")			#Free Open Source PDF Editor
					FLATPAK_INSTALL "io.github.JakubMelka.Pdf4qt" "PDF4QT" "io.github.JakubMelka.Pdf4qt"
				;;

			"Planify")			#Forget about forgetting things
					FLATPAK_INSTALL "io.github.alainm23.planify" "Planify" "io.github.alainm23.planify"
				;;

			"Pomodoro")			#Pomodoro is a timer utility with rules, ideal for better productivity
					FLATPAK_INSTALL "io.gitlab.idevecore.Pomodoro" "Pomodoro" "io.gitlab.idevecore.Pomodoro"
				;;

			"SpeechNote")			#Reading and translating with offline Speech to Text, Text to Speech and Machine Translation
					FLATPAK_INSTALL "flathub net.mkiol.SpeechNote" "SpeechNote" "flathub net.mkiol.SpeechNote"
				;;

			"Teams-For-Linux")			#Unofficial Microsoft Teams client for Linux using Electron
					FLATPAK_INSTALL "com.github.IsmaelMartinez.teams_for_linux" "Teams-For-Linux" "com.github.IsmaelMartinez.teams_for_linux"
				;;

			"Thunderbird")			#Free and open source email, newsfeed, chat, and calendaring client
					ZYPPER_INSTALL "MozillaThunderbird" "Thunderbird" "MozillaThunderbird"
				;;

			"WPS-OFFICE")		#Is a powerful office suite including Writer, Presentation and Spreadsheets
					ZYPPER_INSTALL "wps-office" "WPS-OFFICE" "wps-office"
				;;

			esac
		done

		source ./Start.sh
	fi
	unset IFS
#------------ WORK AND STUDIES end ------------#


	if [[ ! -z $WNS ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
