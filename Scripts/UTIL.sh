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

#----------------- UTILITIES -----------------#
	UTIL=$( zenity --list --checklist\
		2>/dev/null --height=480 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		'Atom-ng' 		"A hackable text editor for the 21st Century"\
		FALSE 		'BalenaEtcher' 		"Powerful utility for writing raw disk images & ISOs to USB keys"\
		FALSE 		'Caffeine-ng' 		"Temporarily inhibit both the screensaver and the sleep power saving mode"\
		FALSE 		'Conky Manager 2' 		"Light-weight system monitor for X and Wayland"\
		FALSE 		'CPU-X' 		"Gathers information on CPU, motherboard and more"\
		FALSE 		'FDM'			"FDM is a powerful modern download accelerator and organizer"\
		FALSE 		'Flameshot' 		"Cross-platform tool to take screenshots with many built-in features"\
		FALSE		'Git'			"A Fast, Scalable, Distributed Free & Open-Source VCS"\
		FALSE		'Github' 		"GUI Open source Electron-based GitHub app"\
		FALSE		'gThumb' 		"Is an open-source software image viewer, image organizer"\
		FALSE		'KeePassxc' 		"Securely store passwords using industry standard encryption"\
		FALSE		'Mailspring' 		"Mailspring is a new version of Nylas Mail"\
		FALSE		'Moovescreen' 		"This Python script moves the window with focus on an adjacent monitor"\
		FALSE		'Nemo' 		"It is a lightweight and functional file manager with many features"\
		FALSE		'Neofetch' 		"Is a command-line system information tool"\
		FALSE		'Notepadqq' 		"A notepad++ clone for Linux loaded with functions and features"\
		FALSE		'OnlyOffice' 		"An office suite that allows to create, view and edit local documents"\
		FALSE		'Peazip' 		"Free file archiver utility, based on Open Source 7-Zip/p7zip"\
		FALSE		'qBittorrent' 		"An open-source Bittorrent client"\
		FALSE		'QDirStat' 		"Graphical application to show where your disk space has gone"\
		FALSE		'Stacer' 		"Linux System Optimizer & Monitoring"\
		FALSE		'TeamViewer' 		"TeamViewer: The Remote Desktop Software"\
		FALSE		'Waydroid' 		"Waydroid uses Linux namespaces to run a full Android system in a container" );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$UTIL"  ]]; then
		zenity --warning  --auto-close\
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $UTIL | tr "|" "\n"); do

			case $option in

			"Atom-ng")		#A hackable text editor for the 21st Century
					ZYPPER_INSTALL "atom-ng" "Atom-ng" "atom-ng"
				;;

			"Balena Etcher")		#A hackable text editor for the 21st Century
					curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.rpm.sh' | codename="tumbleweed" sudo -E bash
					sudo zypper --non-interactive install balena-etcher-electron
					sleep 3
					sudo sed -i '3 c Exec=/opt/balenaEtcher/balena-etcher-electron --no-sandbox %U' /usr/share/applications/balena-etcher-electron.desktop
					sleep 2
				;;

			"Caffeine-ng")		#Temporarily inhibit both the screensaver and the sleep power saving mode
					ZYPPER_INSTALL "caffeine-ng" "Caffeine-ng" "caffeine-ng"
				;;

			"Conky Manager 2")		#Temporarily inhibit both the screensaver and the sleep power saving mode
					ZYPPER_INSTALL "conky-manager2" "Conky Manager 2" "conky-manager2"
				;;

			"CPU-X")		#Temporarily inhibit both the screensaver and the sleep power saving mode
					ZYPPER_INSTALL "cpu-x" "CPU-X" "cpu-x"
				;;

			"FDM")		#Temporarily inhibit both the screensaver and the sleep power saving mode
					FLATPAK_INSTALL "org.freedownloadmanager.Manager" "FDM" "org.freedownloadmanager.Manager"
				;;

			"Flameshot")		#DM is a powerful modern download accelerator and organizer
					ZYPPER_INSTALL "flameshot" "Flameshot" "flameshot"
				;;

			"Git")				#A fast, scalable, distributed free & open-source VCS
					ZYPPER_INSTALL "git" "Git" "git"
					
					#Setup Git name & email? (if installed)
						if [[ $(which git | grep -w "git" | awk {'print $0'}) ]]; then
							zenity --question --title="Git Setup" \
							--text="\nDo you want to Setup Git Name &amp; Email right now?" --width=720 --no-wrap \
							2>/dev/null
							#If Yes, setup
							if [[ $? -eq 0 ]]; then
								#git username
								username=$(zenity --entry --title="Git Setup" --text="Enter Your Name" --width=480 --window-icon="./Icons/Install/git.png" 2>/dev/null)
								#if $username isn't blank, execute command
								if [[ ! -z "$username" ]]; then
									git config --global user.name "\"$username\""
								fi
								#git useremail
								useremail=$(zenity --entry --title="Git Setup" --text="Enter Your Email" --width=480 --window-icon="./Icons/Install/git.png" 2>/dev/null)
								#if $useremail isn't blank, execute command
								if [[ ! -z "$useremail" ]]; then
									git config --global user.email "\"$useremail\""
								fi
							fi
						fi
				;;

			"Github")			#Open source Electron-based GitHub app
					FLATPAK_INSTALL "io.github.shiftey.Desktop" "Github" "io.github.shiftey.Desktop"
				;;

			"gThumb")			#A free and open-source image viewer and image organizer with options to edit images
					ZYPPER_INSTALL "gthumb" "gThumb" "gthumb"
				;;

			"KeePassxc")			#Securely store passwords using industry standard encryption
					ZYPPER_INSTALL "keepassxc" "KeePassxc" "keepassxc"
				;;

			"Movescreen")			#This Python script moves the window with focus on an adjacent monitor
					SNAP_INSTALL "movescreen" "Movescreen" "movescreen"
				;;

			"Nemo")			#It is a lightweight and functional file manager with many features
					ZYPPER_INSTALL "nemo" "Nemo" "nemo"
				;;

			"Neofetch")			#Is a command-line system information tool
					ZYPPER_INSTALL "neofetch" "Neofetch" "neofetch"
				;;

			"Notepadqq")			#An office suite that allows to create, view and edit local documents and features
					ZYPPER_INSTALL "notepadqq" "Notepadqq" "notepadqq"
				;;

			"OnlyOffice")			#An office suite that allows to create, view and edit local documents
					ZYPPER_INSTALL "notepadqq" "Notepadqq" "notepadqq"
				;;

			"Peazip")			#Free file archiver utility, based on Open Source 7-Zip/p7zip
					ZYPPER_INSTALL "notepadqq" "Notepadqq" "notepadqq"
				;;

			"qBittorrent")			#An open-source Bittorrent client
					ZYPPER_INSTALL "notepadqq" "Notepadqq" "notepadqq"
				;;

			"QDirStat")			#Graphical application to show where your disk space has gone, help you to clean it up
					ZYPPER_INSTALL "qdirstat" "QDirStat" "qdirstat"
				;;

			"Stacer")			#Stacer Linux Optimizer & Monitoring
					ZYPPER_INSTALL "stacer" "Stacer" "stacer"
				;;

			"TeamViewer")			#TeamViewer: The Remote Desktop Software
			        Arch=$(GET_SYSTEM_ARCH)
					sudo wget https://download.teamviewer.com/download/linux/teamviewer-suse.$Arch.rpm -P /tmp/
                    sudo zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys install --allow-unsigned-rpm --auto-agree-with-licenses /tmp/teamviewer-suse.$Arch.rpm
				;;
				
			"Waydroid")			#Waydroid uses Linux namespaces to run a full Android system in a container
					ZYPPER_INSTALL "waydroid" "Waydroid" "waydroid"
				;;

			esac
		done

		source ./Start.sh
	fi
	unset IFS
#-------------------- UTILITIES end -------------------#

	if [[ ! -z $UTIL ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
