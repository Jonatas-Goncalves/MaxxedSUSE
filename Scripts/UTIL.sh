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
		2>/dev/null --height=500 --width=720 \
		--title="Select items to Install"\
		--text="The following Software(s) will be Installed"\
		--ok-label "Install" --cancel-label "Skip"\
		--column "Pick" --column "Software(s)" 	--column "Description"\
		FALSE 		'Balena Etcher' 		"Powerful utility for writing raw disk images & ISOs to USB keys"\
		FALSE 		'Conky Manager 2' 		"Light-weight system monitor for X and Wayland"\
		FALSE 		'CPU-X' 		"Gathers information on CPU, motherboard and more"\
		FALSE 		'Distrobox' 		"Use any Linux distribution inside your terminal"\
		FALSE 		'FDM'			"FDM is a powerful modern download accelerator and organizer"\
		FALSE 		'Flameshot' 		"Cross-platform tool to take screenshots with many built-in features"\
		FALSE 		'Flatseal' 		"Manage Flatpak permissions"\
		FALSE 		'Flatsweep' 		"Helps you easily get rid of the residue of uninstall Flatpak package"\
		FALSE 		'K3B' 		"Created to be a feature-rich and easy to handle CD burning application"\
		FALSE 		'Hidamari' 		"Video wallpaper for Linux written in Python"\
		FALSE		'KeePassxc' 		"Securely store passwords using industry standard encryption"\
		FALSE		'KDE Connect' 		"Provides various features to integrate your phone and your computer"\
		FALSE		'Moovescreen' 		"This Python script moves the window with focus on an adjacent monitor"\
		FALSE		'Nemo' 		"It is a lightweight and functional file manager with many features"\
		FALSE		'Neofetch' 		"Is a command-line system information tool"\
		FALSE		'OpenRGB' 		"Open source RGB lighting control that doesn't depend on manufacturer software"\
		FALSE		'Parsec' 		"Connect to work, games, or projects wherever you are, whenever you want"\
		FALSE		'Peazip' 		"Free file archiver utility, based on Open Source 7-Zip/p7zip"\
		FALSE		'PowerISO' 		"Open, extract, burn, create, edit, compress, encrypt, split and convert ISO files"\
		FALSE		'Q4Wine' 		"It will help you to manage wine prefixes and installed applications"\
		FALSE		'qBittorrent' 		"An open-source Bittorrent client"\
		FALSE		'QDirStat' 		"Graphical application to show where your disk space has gone"\
		FALSE		'RustDesk Client' 		"An open-source remote desktop, and alternative to TeamViewer"\
		FALSE		'RustDesk Server' 		"Self-host your own RustDesk server, it is free and open source"\
		FALSE		'Stacer' 		"Linux System Optimizer & Monitoring"\
		FALSE		'TeamViewer' 		"TeamViewer: The Remote Desktop Software"\
		FALSE		'Virtualbox' 		"Powerful virtualization product for enterprise as well as home use"\
		FALSE		'VMware Workstation 17 Player' 		"Utility for running a single virtual machine on a Windows or Linux PC"\
		FALSE		'Waydroid' 		"Waydroid uses Linux namespaces to run a full Android system in a container"\
		FALSE		'Waydroid-Magisk' 		"Install Magisk Manager in Waydroid" );

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

			"Balena Etcher")		#A hackable text editor for the 21st Century
					curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.rpm.sh' | codename="tumbleweed" sudo -E bash
					sudo zypper --non-interactive install balena-etcher-electron
					sleep 3
					sudo sed -i '3 c Exec=/opt/balenaEtcher/balena-etcher-electron --no-sandbox %U' /usr/share/applications/balena-etcher-electron.desktop
					sleep 2
				;;

			"Conky Manager 2")		#Temporarily inhibit both the screensaver and the sleep power saving mode
					ZYPPER_INSTALL "conky-manager2" "Conky Manager 2" "conky-manager2"
				;;

			"CPU-X")		#Temporarily inhibit both the screensaver and the sleep power saving mode
					ZYPPER_INSTALL "cpu-x" "CPU-X" "cpu-x"
				;;

			"Distrobox")		#Use any Linux distribution inside your terminal
					ZYPPER_INSTALL "distrobox" "Distrobox" "distrobox"
				;;

			"FDM")		#Temporarily inhibit both the screensaver and the sleep power saving mode
					FLATPAK_INSTALL "org.freedownloadmanager.Manager" "FDM" "org.freedownloadmanager.Manager"
				;;

			"Flameshot")		#DM is a powerful modern download accelerator and organizer
					ZYPPER_INSTALL "flameshot" "Flameshot" "flameshot"
				;;

			"Flatseal ")		#Manage Flatpak permissions
					FLATPAK_INSTALL "com.github.tchx84.Flatseal" "Flatseal" "com.github.tchx84.Flatseal"
				;;

			"Flatsweep ")		#Helps you easily get rid of the residue of uninstall Flatpak package
					FLATPAK_INSTALL "io.github.giantpinkrobots.flatsweep" "Flatsweep" "io.github.giantpinkrobots.flatsweep"
				;;

			"K3B")		#Created to be a feature-rich and easy to handle CD burning application
					ZYPPER_INSTALL "k3b" "K3B" "k3b"
				;;

			"Hidamari ")		#Video wallpaper for Linux written in Python
					FLATPAK_INSTALL "io.github.jeffshee.Hidamari" "Hidamari" "io.github.jeffshee.Hidamari"
				;;

			"KeePassxc")			#Securely store passwords using industry standard encryption
					ZYPPER_INSTALL "keepassxc" "KeePassxc" "keepassxc"
				;;

			"KDE Connect")			#Provides various features to integrate your phone and your computer
					ZYPPER_INSTALL "kdeconnect-kde" "KDE Connect" "kdeconnect-kde"
					FLATPAK_INSTALL "com.github.bajoja.indicator-kdeconnect" "Indicator-KDEConnect" "com.github.bajoja.indicator-kdeconnect"
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

			"OpenRGB")			#Open source RGB lighting control that doesn't depend on manufacturer software
					ZYPPER_INSTALL "OpenRGB" "OpenRGB" "OpenRGB"
				;;

			"Parsec")			#Connect to work, games, or projects wherever you are, whenever you want
					ZYPPER_INSTALL "parsec-linux" "Parsec" "parsec-linux"
				;;

			"Peazip")			#Free file archiver utility, based on Open Source 7-Zip/p7zip
					ZYPPER_INSTALL "peazip" "Peazip" "peazip"
				;;

			"PowerISO")			#Open, extract, burn, create, edit, compress, encrypt, split and convert ISO files
					FLATPAK_INSTALL "com.poweriso.PowerISO" "PowerISO" "com.poweriso.PowerISO"
				;;

			"Q4Wine")			#It will help you to manage wine prefixes and installed applications
					ZYPPER_INSTALL "q4wine" "Q4Wine" "q4wine"
				;;

			"qBittorrent")			#An open-source Bittorrent client
					ZYPPER_INSTALL "qbittorrent" "qBittorrent" "qbittorrent"
				;;

			"QDirStat")			#Graphical application to show where your disk space has gone, help you to clean it up
					ZYPPER_INSTALL "qdirstat" "QDirStat" "qdirstat"
				;;

			"RustDesk Client")			#An open-source remote desktop, and alternative to TeamViewer
					ZYPPER_INSTALL "rustdesk" "RustDesk Client" "rustdesk"
				;;

			"RustDesk Server")			#Self-host your own RustDesk server, it is free and open source
					ZYPPER_INSTALL "rustdesk-server" "RustDesk Server" "rustdesk-server"
				;;

			"Stacer")			#Stacer Linux Optimizer & Monitoring
					ZYPPER_INSTALL "stacer" "Stacer" "stacer"
				;;

			"TeamViewer")			#TeamViewer: The Remote Desktop Software
			        Arch=$(GET_SYSTEM_ARCH)
					sudo wget https://download.teamviewer.com/download/linux/teamviewer-suse.$Arch.rpm -P /tmp/
                    sudo zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys install --allow-unsigned-rpm --auto-agree-with-licenses /tmp/teamviewer-suse.$Arch.rpm
				;;
				
			"Virtualbox")			#Powerful virtualization product for enterprise as well as home use
					ZYPPER_INSTALL "virtualbox" "Virtualbox" "virtualbox"
					sleep 3
					sudo gpasswd -a $USER vboxusers
					ZYPPER_INSTALL "virtualbox-guest-tools-iso" "virtualbox-guest-tools-iso" "virtualbox-guest-tools-iso"
					echo To use virtualbox needs restart system!
				;;

			"VMware Workstation 17 Player")			#Utility for running a single virtual machine on a Windows or Linux PC
					ZYPPER_INSTALL "vmware-player-updater" "VMware Workstation 17 Player" "vmware-player-updater"
				;;

			"Waydroid")			#Waydroid uses Linux namespaces to run a full Android system in a container
					ZYPPER_INSTALL "waydroid" "Waydroid" "waydroid"
					sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*/& psi=1/" /etc/default/grub
					sudo grub2-mkconfig -o /boot/grub2/grub.cfg
					OPEN_SUSE_VERSION=$(cat /etc/os-release | grep '^ID=')

					# Check openSUSE version and execute appropriate commands
					if [[ "${OPEN_SUSE_VERSION}" == "opensuse-leap" ]]; then
					    sudo mkinitrd /boot/initrd-$(uname -r) $(uname -r)
					elif [[ "${OPEN_SUSE_VERSION}" == "opensuse-tumbleweed" ]]; then
					    sudo dracut -f --regenerate-all
					else
					    echo "Unsupported openSUSE version."
					fi
				;;

			"Waydroid-Magisk")			#Install Magisk Manager in Waydroid
					ZYPPER_INSTALL "waydroid-magisk" "Waydroid-Magisk" "waydroid-magisk"
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
