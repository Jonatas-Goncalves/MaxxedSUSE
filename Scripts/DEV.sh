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

#--------- DEVELOPMENT ----------#
	DEV=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		'Android Studio'	"Android Studio IDE for Android"\
		FALSE 		'Antares SQL'	"A modern, fast and productivity driven SQL client with a focus in UX"\
		FALSE 		'CLion'	"A cross-platform IDE for C and C++"\
		FALSE 		'DBeaver Community'	"Universal Database Manager"\
		FALSE 		'Eclipse IDE JAVA'	"Java IDE, a Git client, XML Editor, Maven and Gradle integration"\
		FALSE		'Git'			"A Fast, Scalable, Distributed Free & Open-Source VCS"\
		FALSE		'Github' 		"GUI Open source Electron-based GitHub app"\
		FALSE		'Gittyup' 		"Graphical Git client designed to help you understand and manage your source code history"\
		FALSE		'GoLand' 		"Capable and Ergonomic Go IDE"\
		FALSE		'IntelliJ IDEA Community' 		"Capable and Ergonomic Java IDE"\
		FALSE		'NVM'			"NVM is a version manager for node.js"\
		FALSE		'Obsidian'			"Markdown-based knowledge base"\
		FALSE		'PhpStorm'		"PHP IDE for Professional Development"\
		FALSE		'Pods'		"Keep track of your podman containers"\
		FALSE		'Podman Desktop'		"Manage Podman and other container engines from a single UI and tray"\
		FALSE		'PyCharm-Community'		"The most intelligent Python IDE"\
		FALSE		'Rider'		"Fast & powerful, cross platform .NET IDE"\
		FALSE		'Scratch'		"Create stories, games, and animations, share with others around the world"\
		FALSE		'Qt Creator'		"Cross-platform IDE tailored for maximum developer productivity"\
		FALSE		'Visual Studio Code'		"Code editing. Redefined"\
		FALSE		'VSCodium' 		"VSCodium is a community-driven, freely distribution of Microsoft's editor VS Code"\
		FALSE		'Whaler'			"Docker Container Management" );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$DEV"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else 
		#this is mandatory for the space in the "Software(s)" column, e.g. 'Android Studio', also IFS unset later
		IFS=$'\n'

		for option in $(echo $DEV | tr "|" "\n"); do

			case $option in
			
			"Android Studio")		#Android Studio IDE
					ZYPPER_INSTALL "android-studio" "Android Studio" "android-studio"
				;;

			"Antares SQL")		#A modern, fast and productivity driven SQL client with a focus in UX
					FLATPAK_INSTALL "it.fabiodistasio.AntaresSQL" "Antares SQL" "it.fabiodistasio.AntaresSQL"
				;;

			"CLion")				#A cross-platform IDE for C and C++
					FLATPAK_INSTALL "com.jetbrains.CLion" "CLion" "com.jetbrains.CLion"
				;;

			"DBeaver Community")				#Universal Database Manager
					FLATPAK_INSTALL "io.dbeaver.DBeaverCommunity" "DBeaver Community" "io.dbeaver.DBeaverCommunity"
				;;

			"Eclipse IDE JAVA")				#Java IDE, a Git client, XML Editor, Maven and Gradle integration
					FLATPAK_INSTALL "org.eclipse.Java" "Eclipse IDE JAVA" "org.eclipse.Java"
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

			"Gittyup")			#Graphical Git client designed to help you understand and manage your source code history
					ZYPPER_INSTALL "Gittyup" "Gittyup" "Gittyup"
				;;

			"GoLand")			#Capable and Ergonomic Go IDE
					FLATPAK_INSTALL "com.jetbrains.GoLand" "GoLand" "com.jetbrains.GoLand"
				;;

			"IntelliJ IDEA Community")			#Capable and Ergonomic Java IDE
					FLATPAK_INSTALL "com.jetbrains.IntelliJ-IDEA-Community" "IntelliJ IDEA Community" "com.jetbrains.IntelliJ-IDEA-Community"
				;;

			"NVM")				#NVM is a version manager for node.js
					curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
					export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
                    [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
				;;

			"Obsidian")				#Markdown-based knowledge base
					FLATPAK_INSTALL "md.obsidian.Obsidian" "Obsidian" "md.obsidian.Obsidian"
				;;

			"PhpStorm")			#PHP IDE for Professional Development
					FLATPAK_INSTALL "com.jetbrains.PhpStorm" "PhpStorm" "com.jetbrains.PhpStorm"
				;;

			"Pods")			#Keep track of your podman containers
					FLATPAK_INSTALL "com.github.marhkb.Pods" "Pods" "com.github.marhkb.Pods"
				;;

			"Podman Desktop")			#Manage Podman and other container engines from a single UI and tray
					FLATPAK_INSTALL "io.podman_desktop.PodmanDesktop" "Podman Desktop" "io.podman_desktop.PodmanDesktop"
				;;

			"PyCharm-Community")			#The most intelligent Python IDE
					ZYPPER_INSTALL "pycharm-community" "PyCharm-Community" "pycharm-community"
				;;

			"Rider")			#Fast & powerful, cross platform .NET IDE
					FLATPAK_INSTALL "com.jetbrains.Rider" "Rider" "com.jetbrains.Rider"
				;;

			"Scratch")			#Create stories, games, and animations, share with others around the world
					FLATPAK_INSTALL "edu.mit.Scratch" "Scratch" "edu.mit.Scratch"
				;;

			"Qt Creator")			#Cross-platform IDE tailored for maximum developer productivity
					ZYPPER_INSTALL "qt6-creator" "Qt Creator" "qt6-creator"
				;;

			"Visual Studio Code")			#Code editing. Redefined
					FLATPAK_INSTALL "com.visualstudio.code" "Visual Studio Code" "com.visualstudio.code"
				;;

			"VSCodium")			#VSCodium is a community-driven, freely-licensed binary distribution of Microsoft's editor VS Code
					Arch=$(GET_SYSTEM_ARCH)
					RPM_VSCODIUM=/tmp/Vscodium.rpm
					curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | grep browser_download_url | grep $Arch[.]rpm | head -n 1 | cut -d '"' -f 4 | sudo wget --base=http://github.com/ -i - -O /tmp/Vscodium.rpm
                    ZYPPER_INSTALL "$RPM_VSCODIUM" "VSCodium" "$RPM_VSCODIUM"
				;;

			"Whaler")		#Docker Container Management
					ZYPPER_INSTALL "com.github.sdv43.whaler" "Whaler" "com.github.sdv43.whaler"
				;;

			esac
		done

		source ./Start.sh
	fi
	unset IFS
#------------ DEVELOPMENT end ------------#


	if [[ ! -z $DEV ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
