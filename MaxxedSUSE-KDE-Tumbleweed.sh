#!/bin/bash
export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
RED=$ESC_SEQ"31;01m"
GREEN=$ESC_SEQ"32;01m"
YELLOW=$ESC_SEQ"33;01m"
BLUE=$ESC_SEQ"34;01m"
MAGENTA=$ESC_SEQ"35;01m"
CYAN=$ESC_SEQ"36;01m"

    output() {
    printf "\E[0;33;40m"
    echo $1
    printf "\E[0m"ku
    }

    displayErr() {
    echo
    echo $1;
    echo
    exit 1;
    }


    clear
    echo
    echo
    echo
    echo
    echo
    echo
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                        MaxxedSUSE Install Script v0.1                                        $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                       Starting Maxxeding your SUSE !!!                                       $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                All changes of this script are described on github !!!                        $COL_RESET"
    echo -e "$GREEN                                             Don't trust me, verify !!!                                       $COL_RESET"
    echo -e "$GREEN                              Check for updates at https://github.com/Jonatas-Goncalves                       $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo
    echo
    sleep 5
    clear

    #++--------------------- Adding user to sudoers ---------------------++#
    echo -e "$MAGENTA**************************************************************************************************************$COL_RESET"
    echo -e "$MAGENTA**************************************************************************************************************$COL_RESET"
    echo -e "$MAGENTA                                         User will be added to sudoers                                        $COL_RESET"
    echo -e "$MAGENTA                                        to run script without interrupt                                       $COL_RESET"
    echo -e "$MAGENTA**************************************************************************************************************$COL_RESET"
    echo -e "$MAGENTA                                 THIS WILL BE REMOVED IN THE END OF SCRIPT !!!                                $COL_RESET"
    echo -e "$MAGENTA**************************************************************************************************************$COL_RESET"
    echo -e "$MAGENTA**************************************************************************************************************$COL_RESET"
    echo
    echo
    sleep 3

whoami=`whoami`
    sudo usermod -aG wheel $(whoami)
    echo '# MaxxedSUSE
    # It needs passwordless sudo functionality.
    '""''"${whoami}"''""' ALL=(ALL) NOPASSWD:ALL
    ' | sudo -E tee /etc/sudoers.d/${whoami} >/dev/null 2>&1

    #++---------------------------'INSTALL ZENITY'------------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                  INSTALLING ZENITY FOR SELECTIVE INSTALL !!!                                 $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    echo
    sudo zypper --non-interactive install zenity
    sudo zypper --non-interactive install at-spi2-core


    #++---------------------- BEGINING OF FIRST RUN OF SCRIPT -------------------++#

zenity --question --text="Are you running script first time?" --height=80 --width=200
if [ $? = 1 ]; then
zenity --info --text="Jumping to the softwares installations!" --height=80 --width=200
    else

zenity --question --text="Add additional repositories to install applications? \n \n OBLIGATORY FOR INSTALL APPS AND GAMES STORES !!!" --height=100 --width=300
    if [ $? = 1 ]; then
zenity --info --text="The default repositories has been kept!" --height=80 --width=200
    else

    #++------------------- INSTALL ADITIONAL REPOSITORIES ------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    echo -e "$YELLOW                             Installing aditional repositories needed for Apps !!!                            $COL_RESET"
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    echo
    sleep 2

    sudo sh -c 'echo -e "[MaxxedSUSE]\nname=MaxxedSUSE\nbaseurl=https://download.opensuse.org/repositories/home:MaxxedSUSE/openSUSE_Tumbleweed/\nenabled=1\ngpgcheck=0\nautorefresh=1\nrepo_gpgcheck=1\ngpgkey=https://download.opensuse.org/repositories/home:MaxxedSUSE/openSUSE_Tumbleweed/repodata/repomd.xml.key" > /etc/zypp/repos.d/MaxxedSUSE.repo'
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ Wine
    sudo zypper --gpg-auto-import-keys addrepo --refresh 'https://download.nvidia.com/opensuse/tumbleweed' NVIDIA
    sudo zypper --gpg-auto-import-keys addrepo https://mirrorcache-us.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed/ snappy
    sudo zypper --gpg-auto-import-keys addrepo -cfp 90 http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
    sudo zypper --gpg-auto-import-keys refresh
    sudo zypper --non-interactive dist-upgrade --from packman --allow-downgrade --allow-vendor-change

    fi

    #++------------------------ UPDATE REPOS AND SYSTEM ---------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                          UPDATE REPOS AND SYSTEM !!!                                         $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sudo zypper refresh
    sudo zypper --non-interactive update --auto-agree-with-licenses --no-recommends


    #++------------------------ CONFIGURE SNAP SERVICE ---------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                         Configuring Snap Services !!!                                        $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

    sudo zypper --non-interactive dup --from snappy
    sudo zypper --non-interactive install snapd
    source /etc/profile && source /home/$USER/.bashrc
    sleep 2
    sudo systemctl enable --now snapd
    sudo systemctl enable --now snapd.apparmor
    sudo systemctl start snapd.apparmor
    sudo systemctl start snapd

    #++---------------------- CONFIGURE FLATPAK SERVICE --------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                        Configuring Flatpak Services !!!                                      $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

    sudo zypper --non-interactive install dbus-1
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    source /etc/profile && source ~/.bashrc
    set XDG_DATA_DIRS "/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"
    sleep 2


    #++------------------------- INSTALL MEDIA CODECS-----------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                            Media Player Codecs !!!                                           $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

    sudo zypper --non-interactive install --allow-vendor-change --from packman ffmpeg gstreamer-plugins-bad lame gstreamer-plugins-libav gstreamer-plugins-ugly gstreamer-plugins-ugly-orig-addon libavresample4 libavdevice57 vlc-codecs


    #++---------------------------'HOSTNAME CHANGER'------------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                              HOSTNAME CHANGER !!!                                            $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text "Hostname Changer! \n This script helps you set your hostname. \n Do you wish to proceed?" --height=80 --width=200
    rc=$?

    if [ "${rc}" == "0" ]; then
        ## answer="yes"
        zenity --question --text "Do you want to provide a hostname? \n(Otherwise we'll generate a cool random one for you)" --height=80 --width=200
        rc=$?

    if [ "${rc}" == "0" ]; then
        ## answer="yes"
        hostAnswer=$(zenity --entry --text "What hostname would you like?" --entry-text "localhost" --height=80 --width=200)
        hostnamectl set-hostname $hostAnswer
        sudo sed -i '/127.0.0.1/c\127.0.0.1       localhost.localdomain   localhost '$hostAnswer'' /etc/hosts
        ##properly sets our new host in /etc/hosts file
        hostname $hostAnswer
        ##avoids need to reboot before showing our new hostname in terminals etc.
        zenity --info --text "New hostname set to "$hostAnswer"." --height=80 --width=200

    else
        ## answer="no"
        RNDHOST=`egrep -i "^[^áéíÓÚàèìÒÙäëüÖÜãõñÃÕÑâêîÔÛ']{8}$" /usr/share/dict/words | shuf | tail -n 1`
        ##get a list of random words without accented characters that are 8chars long, shuffle them, and give us one.
        hostnamectl set-hostname $RNDHOST
        sudo sed -i '/127.0.0.1/c\127.0.0.1       localhost.localdomain   localhost '$RNDHOST'' /etc/hosts
        ##properly sets our new host in /etc/hosts file
        hostname $RNDHOST
        ##avoids need to reboot before showing our new hostname in terminals etc.
        zenity --info --text "New hostname set to "$RNDHOST".\nRun me again at any time to change your hostname again." --height=80 --width=200
    fi

    else
        ##answer="no"
        zenity --error --text "Hostname not changed. Exiting!" --height=80 --width=200
    fi



    #++--------------------- INSTALL GRAPHICS DRIVER -----------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                           Graphics Card Drivers !!!                                          $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

Graphics=$( zenity --list --multiple --checklist\
    2>/dev/null --height=280 --width=500 \
    --title="Select items to Install"\
    --text="The following Software(s) will be Installed"\
    --ok-label "Install" --cancel-label "Skip"\
    --column "Pick" --column "Software(s)" --column "Description"\
    FALSE 		'AMD'               "AMD Radeon Open Source Drivers"\
    FALSE 		'INTEL'             "Intel iGPU Graphics Driver"\
    FALSE 		'NVIDIA 525+'        "Nvidia Graphics drivers 525+"\
    FALSE 		'NVIDIA 470'        "Nvidia Graphics drivers 470"\
    FALSE 		'NVIDIA 390'        "Nvidia Graphics drivers 390"\
    FALSE 		'Vulkan-Libraries'  "Vulkan Libraries (RECOMENDED INSTALL)" );

    #column="2" is sent to output by default
    if [[ $? -eq 0 && -z "$Graphics"  ]]; then
        zenity --warning \
        --text "\nNo Option Selected. Nothing will be installed!"\
        2>/dev/null --no-wrap
    else
        #this is mandatory for the space in the names in "Software(s)" column.
        IFS=$'\n'

    (

    for option in $(echo $Graphics | tr "|" "\n"); do

    case $option in


    "AMD")				#AMD Radeon Drivers Open Source Drivers
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses kernel-firmware-amdgpu libdrm_amdgpu1 libdrm_amdgpu1-32bit libdrm_radeon1 libdrm_radeon1-32bit libvulkan_radeon libvulkan_radeon-32bit libvulkan1 libvulkan1-32bit
    ;;

    "INTEL")			#Intel iGPU Graphics Driver
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses --no-recommends kernel-firmware-intel libdrm_intel1 libdrm_intel1-32bit libvulkan1 libvulkan1-32bit libz1-32bit libvulkan_intel libvulkan_intel-32bit
    ;;

    "NVIDIA 525")			#Nvidia Graphics drivers 525+
    sudo sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf'
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses ffnvcodec-devel kernel-firmware-nvidia nvidia-compute-G06 nvidia-compute-G06-32bit nvidia-compute-utils-G06 nvidia-driver-G06-kmp-default nvidia-drivers-G06 nvidia-gl-G06 nvidia-gl-G06-32bit nvidia-utils-G06 nvidia-video-G06 nvidia-video-G06-32bit
    ;;

    "NVIDIA 470")			#Nvidia Graphics drivers 470 Series
    sudo sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf'
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses nvidia-computeG05 nvidia-computeG05-32bit nvidia-gfxG05-kmp-default nvidia-glG05 nvidia-glG05-32bit x11-video-nvidiaG05 x11-video-nvidiaG05-32bit
    ;;

    "NVIDIA 390")			#Nvidia Graphics drivers 390 Series
    sudo sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf'
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses nvidia-computeG04 nvidia-computeG04-32bit nvidia-gfxG04-kmp-default nvidia-glG04 nvidia-glG04-32bit x11-video-nvidiaG04 x11-video-nvidiaG04-32bit
    ;;

    "Vulkan-Libraries")			#Vulkan Libraries (RECOMENDED INSTALL)
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses libvulkan1 libvulkan1-32bit
    ;;

    esac
    done
    ) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Installing Drivers" 2>/dev/null
    fi

    unset IFS

    #++---------------------- CONFIGURE KERNEL FOR CPU ---------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                        Update Kernel for GPU Otimizations and GPU PCI Passthrough !!!                        $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

CPU=$(zenity --list --title "SELECT YOUR CPU." --text "Select your configuration." \
    --radiolist \
    --column "Select" \
    --column "CPU Model" \
    --height=300 --width=360 \
    --cancel-label "Skip"\
    FALSE "Intel Processor + Nvidia" \
    FALSE "Intel Processor+ Radeon" \
    FALSE "Intel Processor+ Radeon + Nvidia" \
    FALSE "AMD Processor + Nvidia" \
    FALSE "AMD Processor + Radeon" \
    FALSE "AMD Processor + Radeon + Nvidia" );
    if [[ "${CPU}" == "Intel Processor + Nvidia" ]]; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1 rd.driver.blacklist=nouveau intel_iommu=on iommu=pt rd.driver.pre=vfio-pci kvm.ignore_msrs=1/' /etc/default/grub
    fi
    if [[ "${CPU}" == "Intel Processor+ Radeon" ]]; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& intel_iommu=on iommu=pt rd.driver.pre=vfio-pci/' /etc/default/grub
    fi
    if [[ "${CPU}" == "Intel Processor+ Radeon + Nvidia" ]]; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1 rd.driver.blacklist=nouveau intel_iommu=on iommu=pt rd.driver.pre=vfio-pci/' /etc/default/grub
    fi
    if [[ "${CPU}" == "AMD Processor + Nvidia" ]]; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1 rd.driver.blacklist=nouveau iommu=pt amd_iommu=on rd.driver.pre=vfio-pci/' /etc/default/grub
    fi
    if [[ "${CPU}" == "AMD Processor + Radeon" ]]; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& iommu=pt amd_iommu=on rd.driver.pre=vfio-pci/' /etc/default/grub
    fi
    if [[ "${CPU}" == "AMD Processor + Radeon + Nvidia" ]]; then
        sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1 rd.driver.blacklist=nouveau iommu=pt amd_iommu=on rd.driver.pre=vfio-pci/' /etc/default/grub
    fi

    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    sudo mv /boot/initrd-$(uname -r) /boot/initrd-$(uname -r)-nouveau
    sudo dracut -f --regenerate-all

    #++------------------------------ SSD/HDD SWAP OPTIMIZATION -------------------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                          SSD/HDD SWAP OPTIMIZATION                                           $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text="Optimize swap and swapness to reduze disk usage and improve performance and life time?" --height=120 --width=300
    if [ $? = 1 ]; then
        zenity --info --text="Swap has not changed" --height=80 --width=200
    else
        sudo touch /etc/sysctl.d/98-swap.conf
        echo "vm.swappiness=1" | sudo tee /etc/sysctl.d/98-swap.conf
        echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.d/98-swap.conf
    fi

    #++------------------------ INSTALL BRAVE BROWSER-------------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                          Brave Browser switcher !!!                                          $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text="Swap Firefox for Brave, a more secure and private browser based on chrome?\nYou can install Brave in the next steps if you want to keep Firefox" --height=200 --width=350
    if [ $? = 1 ]; then
        zenity --info --text="The firefox has been kept!"
    else
        sudo systemctl stop packagekit
        sudo zypper rm -y firefox
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo zypper addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
        sudo zypper --non-interactive install brave-browser
    fi

    #++------------------------------ INSTALL OPI -------------------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                  OBS Package Installer (CLI) !!!                                     $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

    zenity --question --text="Install Opi (OBS Package Installer)?\nOpi is a tool that finds and installs packages for openSUSE and SLE found in OBS or Packman." --height=120 --width=300
    if [ $? = 1 ]; then
        zenity --info --text="opi was not installed!"
    else
        sudo zypper --non-interactive install opi
    fi

    #++------------------------------ INSTALL ONLYOFFICE -------------------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                            OnlyOffice switcher !!!                                           $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

    zenity --question --text="Swap LibreOffice for OnlyOffice?" --height=80 --width=300
    if [ $? = 1 ]; then
        zenity --info --text="The LibreOffice has been kept!"
    else
        sudo zypper rm -y libreoffice*
        sudo snap install onlyoffice-desktopeditors
    fi

    #++------------------------ CONFIGURE ANDROID TOOLS ---------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                         Configuring Android Services !!!                                        $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

    zenity --question --text="Install and configure android tools for correct access to android phoe storage and if you need flash android phones images and recovery" --height=120 --width=300
    if [ $? = 1 ]; then
        zenity --info --text="The firefox has been kept!"
    else
        sudo zypper --gpg-auto-import-keys refresh
        sudo zypper --non-interactive install android-tools
    fi

    #++---------------------- ENDING OF FIRST RUN OF SCRIPT -------------------++#

fi
    #++---------------------- INSTALL APPLICATION BUNDLE -------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                       Install Applications Bundle !!!                                        $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

Applications=$( zenity --list --multiple --checklist\
    2>/dev/null --height=720 --width=680\
    --title="Select items to Install"\
    --text="The following Software(s) will be Installed"\
    --ok-label "Install" --cancel-label "Skip"\
    --column "Pick" --column "Software(s)" 	--column "Description"\
    FALSE          'Atom'                   "A hackable text editor for the 21st Century"\
    FALSE          'Authy'                  "Two-factor authentication adds an additional layer of protection"\
    FALSE          'BalenaEtcher'		    "Powerful utility for writing raw disk images & ISOs to USB keys"\
    FALSE          'Bitwarden'              "Move fast and securely with the password manager trusted by millions"\
    FALSE          'Bottles'			    "Environments to easily manage and run Windows apps on Linux"\
    FALSE          'Blueman'			    "Is a Bluetooth manager with a modern interface"\
    FALSE          'Brave'		    	    "Secure, Fast & Private Brave Browser with Adblocker"\
    FALSE          'ClamTk'		       	    "Is the graphical interface of the open source antivirus ClamAV"\
    FALSE          'Deezer'			        "Deezer is a music streaming app"\
    FALSE          'Discord'			    "Talk, chat, hang out, and stay close with your friends"\
    FALSE          'Discord Tweks'		    "Otimizations to Discord"\
    FALSE          'Flameshot'			    "Cross-platform tool to take screenshots with many built-in features"\
    FALSE          'Git'		    	    "A cli Fast, Scalable, Distributed Free & Open-Source VCS"\
    FALSE          'Github'		    	    "GUI Open source Electron-based GitHub app"\
    FALSE          'Gnome Disk'			    "View, modify and configure disks and media"\
    FALSE          'Gparted'			    "Free partition editor for graphically managing your disk partitions"\
    FALSE          'gThumb'		    	    "Is an open-source software image viewer, image organizer"\
    FALSE          'Chrome'		    	    "A cross-platform web browser by Google"\
    FALSE          'FDM'		    	    "FDM is a powerful modern download accelerator and organizer"\
    FALSE          'Kdenlive'			    "Free, Open-source, Non-Linear Video Editor by KDE"\
    FALSE          'KeePassxc'			    "Securely store passwords using industry standard encryption"\
    FALSE          'Mailspring'			    "Mailspring is a new version of Nylas Mail"\
    FALSE          'Nemo'		    	    "It is a lightweight and functional file manager with many features"\
    FALSE          'Neofetch'			    "Is a command-line system information tool"\
    FALSE          'Notepadqq'			    "A notepad++ clone for Linux loaded with functions and features"\
    FALSE          'OnlyOffice'			    "An office suite that allows to create, view and edit local documents"\
    FALSE          'OBS Studio'			    "Capturing, compositing, recording, and streaming video content"\
    FALSE          'Peazip'		    	    "Free file archiver utility, based on Open Source 7-Zip/p7zip"\
    FALSE          'Python 3.10'		    "Python 3.10.0 is the newest major release of the Python programming language"\
    FALSE          'qBittorrent'		    "An open-source Bittorrent client"\
    FALSE          'QDirStat'			    "Graphical application to show where your disk space has gone"\
    FALSE          'Signal'		    	    "Signal - Private Messenger: Say Hello to Privacy"\
    FALSE          'Stacer'		    	    "Linux System Optimizer & Monitoring"\
    FALSE          'Stremio'		        "Watch videos, movies, TV series and TV channels instantly"\
    FALSE          'Spotify'			    "Spotify Music Player"\
    FALSE          'Imagewriter'		    "A powerful OS image that copies images to drives byte by byte"\
    FALSE          'TeamViewer'			    "Is without a doubt one of the best remote desktop software programs"\
    FALSE          'Telegram'			    "Official Desktop Client for the Telegram Messenger"\
    FALSE          'Timeshift'			    "System snapshots backup and restore tool for Linux"\
    FALSE          'ulauncher'			    "Is a fast application launcher for Linux"\
    FALSE          'Virtualbox'			    "Powerful virtualization product for enterprise as well as home use"\
    FALSE          'VLC'		    	    "VLC Media Player"\
    FALSE          'VSCodium'		        "VSCodium is a community-driven, freely distribution of Microsoft's editor VS Code"\
    FALSE          'Whatsapp'               "An unofficial WhatsApp desktop application for Linux"\
    FALSE          'WoeUSB-NG'              "Utility that enables you to create your own bootable Windows USB" );

    #column="2" is sent to output by default
    if [[ $? -eq 0 && -z "$Applications"  ]]; then
        zenity --warning \
        --text "\nNo Option Selected. Nothing will be installed!"\
        2>/dev/null --no-wrap
    else
        #this is mandatory for the space in the names in "Software(s)" column, also IFS unset later
        IFS=$'\n'

    (

    for option in $(echo $Applications | tr "|" "\n"); do

    echo -e "#Installing $option";
    case $option in


    "Atom")                 #A hackable text editor for the 21st Century
        sudo flatpak install flathub io.atom.Atom -y
        sleep 3
    ;;

    "Authy")                #Two-factor authentication adds an additional layer of protection beyond passwords
        sudo snap install authy
        sleep 3
    ;;

    "BalenaEtcher")			#Powerful utility for writing raw disk images & ISOs to USB keys
        curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.rpm.sh' | codename="tumbleweed" sudo -E bash
        sudo zypper --non-interactive install balena-etcher-electron
        sleep 10
        sudo sed -i '3 c Exec=/opt/balenaEtcher/balena-etcher-electron --no-sandbox %U' /usr/share/applications/balena-etcher-electron.desktop
        sleep 3
    ;;

    "Bitwarden")			#Move fast and securely with the password manager trusted by millions
        sudo wget https://vault.bitwarden.com/download/?app=desktop&platform=linux -P /tmp/
        sudo wget --user-agent=Linux https://vault.bitwarden.com/download/?app=desktop&platform=linux -P /tmp/ && chmod +x /tmp/Bitwarden-*.appimage
        /tmp/Bitwarden-*.appimage
        sleep 3
    ;;


    "Bottles")				#Uses environments to easily manage and run Windows apps on Linux
        sudo flatpak install flathub com.usebottles.bottles -y
        sleep 3
    ;;

    "Blueman")              #Is a Bluetooth manager with a modern interface
        sudo zypper --non-interactive install blueman
        sleep 3
    ;;

    "Brave")                #Brave Browser
        sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
        sudo zypper addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
        sudo zypper --non-interactive install brave-browser
        sleep 3
    ;;

    "ClamTk")               #Is the graphical interface of the open source antivirus ClamAV
        sudo flatpak install flathub com.gitlab.davem.ClamTk -y
        sleep 3
    ;;

    "Deezer")              #Deezer is a music streaming app
        sudo zypper --non-interactive install deezer
        sleep 3
    ;;

    "Discord")              #Talk, chat, hang out, and stay close with your friends
        sudo flatpak install flathub com.discordapp.Discord -y
        sleep 3
    ;;

    "DiscordTweks")			#Otimizations to Discord
        sudo sed -i 's_Exec=/usr/bin/discord_Exec=/usr/bin/discord --no-sandbox --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy_gI' /usr/share/applications/discord.desktop
        sleep 3
    ;;

    "Flameshot")			#Cross-platform tool to take screenshots with many built-in features to save you time
        sudo flatpak install flathub org.flameshot.Flameshot -y
        sleep 3
    ;;

    "git")                  #A fast, scalable, distributed free & open-source
        sudo sudo zypper --non-interactive install git
        sleep 3
    ;;

    "Github")               #Open source Electron-based GitHub app
        flatpak install flathub io.github.shiftey.Desktop -y
        sleep 3
    ;;

    "Gnome Disk")           #View, modify and configure disks and media
        sudo zypper --non-interactive install gnome-disk-utility
        sleep 3
    ;;

    "Gparted")              #Is a free partition editor for graphically managing your disk partitions
        sudo zypper --non-interactive install gparted
        sleep 3
    ;;

    "gThumb")               #A free and open-source image viewer and image organizer with options to edit images
        sudo zypper --non-interactive install gthumb
        sleep 3
    ;;

    "Chrome")               #Google Chrome web browser
        sudo zypper ar http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
        sudo wget https://dl.google.com/linux/linux_signing_key.pub -P /tmp/
        sudo rpm --import /tmp/linux_signing_key.pub
        sudo zypper ref
        sudo zypper --non-interactive install google-chrome-stable
        sleep 3
    ;;

    "FDM")                  #FDM is a powerful modern download accelerator and organizer.
        sudo flatpak install flathub org.freedownloadmanager.Manager -y
        sleep 3
    ;;

    "Kdenlive")             #Free, Open-source, Non-Linear Video Editor by KDE
        sudo zypper --non-interactive install kdenlive
        sleep 3
    ;;

    "KeePassxc")			#Securely store passwords using industry standard encryption
        sudo snap install keepassxc
        sleep 3
    ;;

    "Mailspring")			#Mailspring Mail Client
        sudo snap install mailspring
        sleep 3
    ;;

    "Nemo")                 #It is a lightweight and functional file manager with many features
        sudo zypper --non-interactive install nemo
        sleep 3
    ;;

    "Neofetch")             #Is a command-line system information tool
        sudo zypper --non-interactive install neofetch
        sleep 3
    ;;

    "Notepadqq")			#A notepad++ clone for Linux loaded with functions and features
        sudo zypper --non-interactive install notepadqq
        sleep 3
    ;;

    "OBS Studio")			#Designed for capturing, compositing, encoding, recording, and streaming video content
        sudo flatpak install flathub com.obsproject.Studio -y
        sleep 3
    ;;

    "OnlyOffice")              #An office suite that allows to create, view and edit local documents
        sudo snap install onlyoffice-desktopeditors
        sleep 3
    ;;

    "Peazip")               #Free file archiver utility, based on Open Source technologies of 7-Zip/p7zip
        sudo zypper --non-interactive install peazip
        sleep 3
    ;;

    "Python 3.10.0")        #Python 3.10.0 is the newest major release of the Python programming language
        sudo zypper --non-interactive install python310 python310-base python310-devel python310-curses python310-dbm python310-pip python310-tools python310-setuptools
        sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.6 50
        sudo update-alternatives --install /usr/bin/python3 python3 /usr/bin/python3.10 50
        sudo update-alternatives --set python3 /usr/bin/python3.10
        sleep 3
    ;;

    "qBittorrent")             #An open-source Bittorrent client
        sudo flatpak install flathub org.qbittorrent.qBittorrent -y
        sleep 3
    ;;

    "QDirStat")             #Graphical application to show where your disk space has gone, help you to clean it up
        sudo zypper --non-interactive install qdirstat
        sleep 3
    ;;

    "Signal")               #Signal - Private Messenger: Say Hello to Privacy
        sudo snap install signal-desktop
        sleep 3
    ;;

    "Stacer")               #Stacer Linux Optimizer & Monitoring
        sudo curl -sSfL https://api.github.com/repos/oguzhaninan/Stacer/releases/latest | grep browser_download_url | grep 'amd64[.]rpm' | head -n 1 | cut -d '"' -f 4 | sudo wget --base=http://github.com/ -i - -O /tmp/Stacer.rpm
        sudo zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys install --auto-agree-with-licenses /tmp/Stacer.rpm
        sleep 3
    ;;

    "Stremio")              #Watch videos, movies, TV series and TV channels instantly
        sudo flatpak install flathub com.stremio.Stremio -y
        sleep 3
    ;;


    "Spotify")              #Spotify Music Player
        sudo snap install spotify
        sleep 3
    ;;

    "Imagewriter")			#A powerful OS image that copies images to drives byte by byte
        sudo zypper --non-interactive install imagewriter
        sleep 3
    ;;

    "TeamViewer")			#Is without a doubt one of the best remote desktop software programs
        sudo wget https://download.teamviewer.com/download/linux/teamviewer-suse.x86_64.rpm -P /tmp/
        sudo zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys install --auto-agree-with-licenses /tmp/teamviewer-suse.x86_64.rpm
        sleep 3
    ;;

    "Telegram")             #Official Desktop Client for the Telegram Messenger
        sudo zypper --non-interactive install telegram-desktop
        sleep 3
    ;;

    "Timeshift")			#System snapshots backup and restore tool for Linux
        sudo zypper --non-interactive install timeshift
        sleep 3
    ;;

    "Virtualbox")			#Powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use
        sudo zypper --non-interactive install virtualbox
        sleep 3
        sudo gpasswd -a $USER vboxusers
        sleep 2
    ;;

    "VLC")                  #VLC Media Player
        sudo zypper --non-interactive install vlc
        sleep 3
    ;;

    "VSCodium")             #VSCodium is a community-driven, freely-licensed binary distribution of Microsoft's editor VS Code
        curl -s https://api.github.com/repos/VSCodium/vscodium/releases/latest | grep browser_download_url | grep 'x86_64[.]rpm' | head -n 1 | cut -d '"' -f 4 | sudo wget --base=http://github.com/ -i - -O /tmp/Vscodium.rpm
        sudo zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys install --auto-agree-with-licenses /tmp/Vscodium.rpm
        sleep 3
    ;;

    "Whatsapp")            #An unofficial WhatsApp desktop application for Linux
        sudo snap install whatsapp-for-linux
        sleep 3
    ;;

    "WoeUSB-NG")            #Utility that enables you to create your own bootable Windows USB
        sudo zypper --non-interactive install woeusb-ng
        sleep 3
    ;;


    esac
    done
    )| zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Installing Softwares(s)" 2>/dev/null
    fi

    unset IFS

    if [[ ! -z $Applications ]]; then
        Title=$1
        Text=$2
    echo
    echo
    echo -e "$YELLOW   Complete! Selecteds Softwares Installed !!!   $COL_RESET"
    echo
    echo

    fi

    #++---------------------- INSTALL GAMES SOFTWARES -------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                       Install Games Softwares !!!                                        $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

Games=$( zenity --list --multiple --checklist\
    2>/dev/null --height=720 --width=680\
    --title="Select items to Install"\
    --text="The following Software(s) will be Installed"\
    --ok-label "Install" --cancel-label "Skip"\
    --column "Pick" --column "Software(s)" 	--column "Description"\
    FALSE          'AntimicroX'             "Used to map gamepad keys to keyboard, mouse, scripts and macros"\
    FALSE          'BoilR'                  "Synchronize games from other platforms into your Steam library"\
    FALSE          'Ludusavi'               "A tool for backing up your PC video game save data"\
    FALSE          'GameHub'                "Supports non-native games as well as native games for Linux"\
    FALSE          'Gamemode'               "Allows games to request a set of optimisations for a games process"\
    FALSE          'Gamescope'              "Allows for games to run in an isolated Xwayland instance"\
    FALSE          'GOverlay'               "A Graphical UI to help manage Linux monitoring overlays"\
    FALSE          'Grapejuice'             "Grapejuice is a launcher for the popular Roblox platform"\
    FALSE          'Lutris'                 "Play all your games on Linux"\
    FALSE          'Lutris-Flatpak'         "Flatpak version of Lutris (Better libs compatibility)"\
    FALSE          'MangoHud'               "A Vulkan and OpenGL overlay for monitoring FPS, temp, CPU/GPU..."\
    FALSE          'vkBasalt'               "Vulkan post processing layer to enhance the visual graphics of games"\
    FALSE          'HeroicGamesLauncher'    "Open Source Game Launcher for Epic and GOG"\
    FALSE          'ProtonUP'               "Install and manage Custom Proton's for Steam and Wine-GE for Lutris"\
    FALSE          'Steam-Native'           "Is a digital game distribution platform for computers"\
    FALSE          'Steam-Flatpack'         "Flatpak version of Steam, Recommended for Stream and BigPicture mode"\
    FALSE          'Sunshine'               "Sunshine is a Gamestream host for Moonlight" );

    #column="2" is sent to output by default
    if [[ $? -eq 0 && -z "$Games"  ]]; then
        zenity --warning \
        --text "\nNo Option Selected. Nothing will be installed!"\
        2>/dev/null --no-wrap
    else
        #this is mandatory for the space in the names in "Software(s)" column, also IFS unset later
        IFS=$'\n'

    (

    for option in $(echo $Games | tr "|" "\n"); do

    echo -e "#Installing $option";
    case $option in


    "AntimicroX")           #Used to map gamepad keys to keyboard, mouse, scripts and macros
        sudo zypper --non-interactive install antimicrox
        sleep 3
    ;;

    "BoilR")                #Synchronize games from other platforms into your Steam library
        sudo flatpak install flathub io.github.philipk.boilr -y
        sleep 3
    ;;

    "Ludusavi")             #A tool for backing up your PC video game save data
        sudo flatpak install flathub com.github.mtkennerly.ludusavi -y
        sleep 3
    ;;

    "GameHub")              #Supports non-native games as well as native games for Linux
        curl -s https://api.github.com/repos/tkashkin/GameHub/releases/latest | grep browser_download_url | grep '[.]flatpak' | head -n 1 | cut -d '"' -f 4 | sudo wget --base=http://github.com/ -i - -O /tmp/GameHub.flatpak
        sudo flatpak install /tmp/GameHub.flatpak -y
        sleep 3
    ;;

    "Gamemode")             #Allows games to request a set of optimisations for a games process
        sudo zypper --non-interactive install gamemoded
        sleep 3
    ;;

    "Gamescope")            #Allows for games to run in an isolated Xwayland instance
        sudo zypper --non-interactive install gamescope
        sleep 3
    ;;

    "GOverlay")             #A Graphical UI to help manage Linux monitoring overlays
        sudo zypper --non-interactive install goverlay
        sleep 3
    ;;

    "Grapejuice")           #Grapejuice is a launcher for the popular Roblox platform
        sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/Emulators:/Wine/15.4/ Wine
        sudo zypper --non-interactive install wine wine-mono wine-gecko libvulkan1 libvulkan1-32bit gettext-runtime git python3-devel python3-pip cairo-devel gobject-introspection-devel make xdg-utils gtk3-devel python3-gobject-Gdk
        sudo zypper --non-interactive install python310 python310-base python310-devel python310-curses python310-dbm python310-pip python310-tools python310-setuptools
        git clone --depth=1 https://gitlab.com/brinkervii/grapejuice.git /tmp/grapejuice
        cd /tmp/grapejuice && ./install.py
        cd
        sleep 3
    ;;

    "Lutris")               #Play all your games on Linux
        sudo zypper --non-interactive install lutris
        sleep 3
    ;;

    "Lutris-Flatpak")               #Play all your games on Linux
        sudo flatpak install flathub net.lutris.Lutris -y
        sleep 3
    ;;

    "MangoHud")             #A Vulkan and OpenGL overlay for monitoring FPS, temp, CPU/GPU...
        sudo zypper --non-interactive install mangohud
        sleep 3
    ;;

    "vkBasalt")             #Vulkan post processing layer to enhance the visual graphics of games
        sudo zypper --non-interactive install vkbasalt
        sleep 3
    ;;

    "HeroicGamesLauncher")  #Open Source Game Launcher for Epic and GOG
        sudo zypper --non-interactive install HeroicGamesLauncher
        sleep 2
    ;;

    "ProtonUP")             #Install and manage Custom Proton's for Steam and Wine-GE for Lutris
        sudo flatpak install flathub net.davidotek.pupgui2 -y
        sleep 3
    ;;

    "Steam-Native")          #Is a digital game distribution platform for computers
        sudo zypper --non-interactive install steam
        sleep 3
    ;;

    "Steam-Flatpak")        #Flatpak version of Steam, Recommended for Stream and BigPicture mode
        sudo flatpak install flathub com.valvesoftware.Steam -y
        sudo zypper --non-interactive install steam-devices
        sleep 3
    ;;

    "Sunshine")              #Sunshine is a Gamestream host for Moonlight
        curl -s https://api.github.com/repos/LizardByte/Sunshine/releases/latest | grep browser_download_url | grep 'sunshine_x86_64[.]flatpak' | head -n 1 | cut -d '"' -f 4 | sudo wget --base=http://github.com/ -i - -O /tmp/Sunshine.flatpak
        sudo flatpak install --system /tmp/Sunshine.flatpak -y
        flatpak run --command=additional-install.sh dev.lizardbyte.sunshine
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
        echo "ExecStart=flatpak run dev.lizardbyte.sunshine" | sudo tee --append ~/.config/systemd/user/sunshine.service
        echo "Restart=on-failure" | sudo tee --append ~/.config/systemd/user/sunshine.service
        echo "RestartSec=5s" | sudo tee --append ~/.config/systemd/user/sunshine.service
        echo "ExecStop=flatpak kill dev.lizardbyte.sunshine" | sudo tee --append ~/.config/systemd/user/sunshine.service
        echo "" | sudo tee --append ~/.config/systemd/user/sunshine.service
        echo "[Install]" | sudo tee --append ~/.config/systemd/user/sunshine.service
        echo "WantedBy=graphical-session.target" | sudo tee --append ~/.config/systemd/user/sunshine.service
        sleep 3
    ;;

    esac
    done
    )| zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Installing Games(s)" 2>/dev/null
    fi

    unset IFS

    if [[ ! -z $Games ]]; then
        Title=$1
        Text=$2
    echo
    echo
    echo -e "$YELLOW   Complete! Selecteds Games Installed !!!   $COL_RESET"
    echo
    echo

    fi

    #++------------------------- BONUS INSTALL-----------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                        Itch.io Bonus Installation !!!                                        $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text="Would you like to install Itch.io, the best indie gaming platform?" --height=80 --width=300
    if [ $? = 0 ]; then
        sudo wget --user-agent=Linux --content-disposition -E -c https://itch.io/app/download -P /tmp/
        sudo chmod +x /tmp/itch-setup && /tmp/./itch-setup
        sudo mv ~/.itch /opt/itch
        sudo mv ~/.local/share/applications/io.itch.itch.desktop /usr/share/applications/io.itch.itch.desktop
        sudo sed -i '4 c TryExec=/opt/itch/itch' /usr/share/applications/io.itch.itch.desktop
        sudo sed -i '5 c Exec=/opt/itch/itch --no-sandbox %U' /usr/share/applications/io.itch.itch.desktop
        sudo sed -i '6 c Icon=/opt/itch/icon.png' /usr/share/applications/io.itch.itch.desktop
        sudo sed -i '2 c /opt/itch/app-25.6.2/itch --no-sandbox --prefer-launch --appname itch -- "$@"' /opt/itch/itch
        sleep 10
    fi


    #++--------------------- Remove user from sudoers ---------------------++#
    echo -e "$BLUE**************************************************************************************************************$COL_RESET"
    echo -e "$BLUE                                         Remove user from sudoers !!!                                         $COL_RESET"
    echo -e "$BLUE**************************************************************************************************************$COL_RESET"
    sleep 2
    sudo gpasswd -d $(whoami) wheel

    #++--------------------------- Cleaning temp --------------------------++#
    echo -e "$BLUE**************************************************************************************************************$COL_RESET"
    echo -e "$BLUE                                         Cleaning temporary files !!!                                         $COL_RESET"
    echo -e "$BLUE**************************************************************************************************************$COL_RESET"
    sudo rm -rf /tmp/*.*
    sleep 2

    #++--------------------------- SCRIPT END -----------------------------++#
    clear
    echo
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN                                                     Done...                                                  $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN                                        MaxxedSUSE Install Script v0.1                                        $COL_RESET"
    echo -e "$GREEN                                                   Finish !!!                                                 $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                   All contributions to this project are welcome.                             $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                               Clone this repo, make your changes and pull request.                           $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    clear

    echo
    echo -e "$RED**************************************************************************************************************$COL_RESET"
    echo -e "$RED                               WEE MUST REBOOT NOW  TO FINALIZE INSTALLATION !!!                              $COL_RESET"
    echo -e "$RED**************************************************************************************************************$COL_RESET"
    echo -e "$RED                           Check for updates at https://github.com/Jonatas-Goncalves                          $COL_RESET"
    echo -e "$RED                                           Thanks for use my script!                                          $COL_RESET"
    echo -e "$RED                                              Good Work or Playing!                                           $COL_RESET"
    echo -e "$RED**************************************************************************************************************$COL_RESET"
    sleep 3
    echo

zenity --question --text="Some apps and system components don't work properly until we restart!\nReboot system?" --height=120 --width=300
    if [ $? = 1 ]; then
        zenity --info --text="Exiting..."
    else
        sudo reboot
    fi
