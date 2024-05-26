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

#------------- GAMES AND TOOLS -------------#
	GNT=$( zenity --list --checklist\
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE		AntimicroX 		"Used to map gamepad keys to keyboard, mouse, scripts and macros"\
		FALSE		BoilR 		"Synchronize games from other platforms into your Steam library"\
		FALSE		Ludusavi 		"A tool for backing up your PC video game save data"\
		FALSE		GameHub 		"Supports non-native games as well as native games for Linux"\
		FALSE		Gamemode 		"Allows games to request a set of optimisations for a games process"\
		FALSE		Gamescope 		"Allows for games to run in an isolated Xwayland instance"\
		FALSE		GOverlay 		"A Graphical UI to help manage Linux monitoring overlays"\
		FALSE		Jstest-GTK 		"A simple joystick tester based on Gtk+"\
		FALSE		MangoHud 		"A Vulkan and OpenGL overlay for monitoring FPS, temp, CPU/GPU..."\
		FALSE		Moonlight-QT 		"GameStream client for PCs (Windows, Mac, Linux, and Steam Link)"\
		FALSE		Oversteer 		"Steering Wheel Manager for GNU/Linux"\
		FALSE		vkBasalt 		"Vulkan post processing layer to enhance the visual graphics of games"\
		FALSE		PrismLauncher 		"Custom launcher for Minecraft that allows you to easily manage multiple installations"\
		FALSE 		ProtonPlus 		"A simple Wine and Proton-based compatiblity tools manager"\
		FALSE 		ProtonUP 		"Install and manage Custom Proton's for Steam and Wine-GE for Lutris"\
		FALSE 		SC-Controller 		" User-mode driver and GTK3 based GUI for Steam Controller "\
		FALSE 		Sunshine 		"Sunshine is a Gamestream host for Moonlight"\
		FALSE		XWiimote-ng 		"Xwiimote-ng is an open-source device driver for Nintendo Wii / Wii U remotes"\
		FALSE		XboxDrv 		"Userspace Xbox gamepad driver and input remapper"\
		FALSE		Xone 		"Linux kernel driver for Xbox One and Xbox Series X|S accessories" );

	#column="2" is sent to output by default
	if [[ $? -eq 0 && -z "$GNT"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be installed!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in the names in "Software(s)" column, also IFS unset later
		IFS=$'\n'

		for option in $(echo $GNT | tr "|" "\n"); do

			case $option in

			"AntimicroX")			#Used to map gamepad keys to keyboard, mouse, scripts and macros
					ZYPPER_INSTALL "antimicrox" "AntimicroX" "antimicrox"
				;;

			"BoilR")			#Synchronize games from other platforms into your Steam library
					FLATPAK_INSTALL "io.github.philipk.boilr" "BoilR" "io.github.philipk.boilr"
				;;

			"Ludusavi")			#A tool for backing up your PC video game save data
					FLATPAK_INSTALL "com.github.mtkennerly.ludusavi" "Ludusavi" "com.github.mtkennerly.ludusavi"
				;;

			"GameHub")			#Supports non-native games as well as native games for Linux
					ZYPPER_INSTALL "gamehub" "GameHub" "gamehub"
				;;

			"Gamemode")			#Allows games to request a set of optimisations for a games process
					ZYPPER_INSTALL "gamemoded" "Gamemode" "gamemoded"
				;;

			"Gamescope")			#Allows for games to run in an isolated Xwayland instance
					ZYPPER_INSTALL "gamescope" "Gamescope" "gamescope"
				;;

			"GOverlay")			#A Graphical UI to help manage Linux monitoring overlays
					ZYPPER_INSTALL "goverlay" "GOverlay" "goverlay"
				;;

			"Jstest-GTK")			#A simple joystick tester based on Gtk+
					ZYPPER_INSTALL "jstest-gtk" "Ludusavi" "jstest-gtk"
				;;

			"MangoHud")			#A Vulkan and OpenGL overlay for monitoring FPS, temp, CPU/GPU...
					ZYPPER_INSTALL "mangohud" "MangoHud" "mangohud"
				;;

			"Moonlight-QT")			#GameStream client for PCs (Windows, Mac, Linux, and Steam Link)
					ZYPPER_INSTALL "moonlight-qt" "Moonlight-QT" "moonlight-qt"
				;;

			"Oversteer")			#Steering Wheel Manager for GNU/Linux
					ZYPPER_INSTALL "oversteer" "Oversteer" "oversteer"
				;;

			"vkBasalt")			#Vulkan post processing layer to enhance the visual graphics of games
					ZYPPER_INSTALL "vkbasalt" "vkBasalt" "vkbasalt"
				;;

			"PrismLauncher")			#Custom launcher for Minecraft that allows you to easily manage multiple installations
					ZYPPER_INSTALL "prismlauncher-qt5" "PrismLauncher" "prismlauncher-qt5"
				;;

			"ProtonPlus")		#A simple Wine and Proton-based compatiblity tools manager
					FLATPAK_INSTALL "com.vysp3r.ProtonPlus" "ProtonPlus" "com.vysp3r.ProtonPlus"
				;;

			"ProtonUP")		#Install and manage Custom Proton's for Steam and Wine-GE for Lutris
					FLATPAK_INSTALL "net.davidotek.pupgui2" "ProtonUP" "net.davidotek.pupgui2"
				;;

			"SC-Controller")		# User-mode driver and GTK3 based GUI for Steam Controller
					ZYPPER_INSTALL "sc-controller" "SC-Controller" "sc-controller"
				;;

			"Sunshine")			#Sunshine is a Gamestream host for Moonlight
					ZYPPER_INSTALL "sunshine" "Sunshine" "sunshine"
					sudo usermod -a -G input $USER
					echo 'KERNEL=="uinput", GROUP="input", MODE="0660", OPTIONS+="static_node=uinput"' | \
sudo tee /etc/udev/rules.d/85-sunshine-input.rules
					mkdir -p ~/.config/systemd/user/
					sudo touch ~/.config/systemd/user/sunshine.service
					echo "[Unit]" | sudo tee --append  ~/.config/systemd/user/sunshine.service
					echo "Description=Sunshine self-hosted game stream host for Moonlight." | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "StartLimitIntervalSec=500" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "StartLimitBurst=5" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "[Service]" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "ExecStart=/usr/bin/sunshine" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "Restart=on-failure" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "RestartSec=5s" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "[Install]" | sudo tee --append ~/.config/systemd/user/sunshine.service
					echo "WantedBy=graphical-session.target" | sudo tee --append ~/.config/systemd/user/sunshine.service
					sleep 3
				;;

			"XWiimote-ng")		#Xwiimote-ng is an open-source device driver for Nintendo Wii / Wii U remotes
					ZYPPER_INSTALL "xwiimote-ng" "XWiimote-ng" "xwiimote-ng"
				;;

			"XboxDrv")		#Userspace Xbox gamepad driver and input remapper
					ZYPPER_INSTALL "xboxdrv" "XboxDrv" "xboxdrv"
				;;

			"Xone")		#Linux kernel driver for Xbox One and Xbox Series X|S accessories
					ZYPPER_INSTALL "xone-kmp-default" "Xone" "xone-kmp-default"
				;;

			esac
		done

		source ./Start.sh
	fi
	unset IFS
#----------------- GAMES AND TOOLS end ------------------#

	if [[ ! -z $GNT ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Softwares Installed'
	fi
fi
