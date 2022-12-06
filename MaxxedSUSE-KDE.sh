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
    echo -e "$GREEN***********************************************************$COL_RESET"
    echo -e "$GREEN***********************************************************$COL_RESET"
    echo -e "$GREEN              MaxxedSUSE Install Script v0.1               $COL_RESET"
    echo -e "$GREEN***********************************************************$COL_RESET"
    echo -e "$GREEN             Starting Maxxeding your SUSE !!!              $COL_RESET"
    echo -e "$GREEN***********************************************************$COL_RESET"
    echo -e "$GREEN***********************************************************$COL_RESET"
    echo
    echo
    sleep 3
    echo
    echo
    echo -e "$RED************************************************************$COL_RESET"
    echo -e "$RED   All changes of this script are described on github !!!   $COL_RESET"
    echo -e "$RED************************************************************$COL_RESET"
    echo -e "$RED                  Don't trust me, verify !!!                $COL_RESET"
    echo -e "$RED************************************************************$COL_RESET"
    echo -e "$RED Check for updates at https://github.com/Jonatas-Goncalves $COL_RESET"
    echo -e "$RED************************************************************$COL_RESET"
    echo
    echo
    sleep 3

    #++--------------------- Adding user to sudoers ---------------------++#
    echo -e "$MAGENTA***********************************************************$COL_RESET"
    echo -e "$MAGENTA***********************************************************$COL_RESET"
    echo -e "$MAGENTA              User will be added to sudoers                $COL_RESET"
    echo -e "$MAGENTA             to run script without interrupt               $COL_RESET"
    echo -e "$MAGENTA***********************************************************$COL_RESET"
    echo -e "$MAGENTA      THIS WILL BE REMOVED IN THE END OF SCRIPT !!!        $COL_RESET"
    echo -e "$MAGENTA***********************************************************$COL_RESET"
    echo -e "$MAGENTA***********************************************************$COL_RESET"
    sleep 4

whoami=`whoami`
    sudo usermod -aG wheel $(whoami)
    echo '# MaxxedSUSE
    # It needs passwordless sudo functionality.
    '""''"${whoami}"''""' ALL=(ALL) NOPASSWD:ALL
    ' | sudo -E tee /etc/sudoers.d/${whoami} >/dev/null 2>&1

    #++---------------------- BEGINING OF FIRST RUN OF SCRIPT -------------------++#

zenity --question --text="Are you running script first time?"
if [ $? = 1 ]; then
    zenity --info --text="Jumping to the softwares installations!"
else

    #++---------------------------'INSTALL ZENITY'------------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW       INSTALLING ZENITY FOR SELECTIVE INSTALL !!!         $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sudo zypper --non-interactive install zenity
    sudo zypper --non-interactive install at-spi2-core

    sleep 2

zenity --question --text="Add additional repositories to install applications? \n \n OBLIGATORY FOR INSTALL APPS AND GAMES STORES !!!"
    if [ $? = 1 ]; then
    zenity --info --text="The default repositories has been kept!"
else

    sudo zypper --gpg-auto-import-keys addrepo --refresh https://download.nvidia.com/opensuse/tumbleweed NVIDIA
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/mozilla/openSUSE_Tumbleweed/ Mozzila
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/openSUSE:/Tumbleweed/standard/ openSUSE:Tumbleweed
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/openSUSE:/Factory:/NonFree/standard/
    sudo zypper --gpg-auto-import-keys addrepo http://mirror.uepg.br/opensuse/tumbleweed/repo/oss/ Universidade Estadual de Ponta Grossa-OSS
    sudo zypper --gpg-auto-import-keys addrepo http://mirror.uepg.br/opensuse/tumbleweed/repo/non-oss/ Universidade Estadual de Ponta Grossa-NonOSS
    sudo zypper --gpg-auto-import-keys addrepo http://mirror.uepg.br/opensuse/factory/repo/oss/ Universidade Estadual de Ponta Grossa-Factory-OSS
    sudo zypper --gpg-auto-import-keys addrepo http://mirror.uepg.br/opensuse/factory/repo/non-oss/ Universidade Estadual de Ponta Grossa-Factory-NonOSS
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/home:/munix9/openSUSE_Tumbleweed/ munix9
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/home:/munix9:/test/openSUSE_Tumbleweed/ munix9:test
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/ Dead_Mozay
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/home:jason-kurzik/openSUSE_Tumbleweed/ jason-kurzik
    sudo zypper --gpg-auto-import-keys addrepo -cfp 90 http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
    sudo zypper --gpg-auto-import-keys refresh
    sudo zypper --non-interactive dist-upgrade --from packman --allow-downgrade --allow-vendor-change
fi

    #++------------------------ CONFIGURE SNAP SERVICE ---------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                 Configuring Snap Services !!!             $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

    sudo zypper --non-interactive dup --from snappy
    sudo zypper --non-interactive install snapd
    source /etc/profile && source ~/.bashrc
    sleep 3
    sudo systemctl enable --now snapd
    sleep 3
    sudo systemctl enable --now snapd.apparmor
    sleep 3
    sudo systemctl start snapd.apparmor
    sleep 3
    sudo systemctl start snapd
    sleep 3

    #++---------------------- CONFIGURE FLATPAK SERVICE --------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW              Configuring Flatpak Services !!!             $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

    sudo zypper --non-interactive install dbus-1
    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
    source /etc/profile && source ~/.bashrc
    set XDG_DATA_DIRS "/var/lib/flatpak/exports/share:$XDG_DATA_DIRS"


    #++------------------------- INSTALL MEDIA CODECS-----------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                    Media Player Codecs !!!                $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

    sudo zypper --non-interactive install --allow-vendor-change --from packman ffmpeg gstreamer-plugins-bad lame gstreamer-plugins-libav gstreamer-plugins-ugly gstreamer-plugins-ugly-orig-addon libavresample4 libavdevice57 vlc-codecs


    #++---------------------------'HOSTNAME CHANGER'------------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                  HOSTNAME CHANGER !!!                     $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text "Hostname Changer! \n This script helps you set your hostname. \n Do you wish to proceed?"
    rc=$?

if [ "${rc}" == "0" ]; then
    ## answer="yes"
zenity --question --text "Do you want to provide a hostname? \n(Otherwise we'll generate a cool random one for you)"

    rc=$?

if [ "${rc}" == "0" ]; then
    ## answer="yes"
    hostAnswer=$(zenity --entry --text "What hostname would you like?" --entry-text "localhost")
    hostnamectl set-hostname $hostAnswer
    sudo sed -i '/127.0.0.1/c\127.0.0.1       localhost.localdomain   localhost '$hostAnswer'' /etc/hosts
    ##properly sets our new host in /etc/hosts file
    hostname $hostAnswer
    ##avoids need to reboot before showing our new hostname in terminals etc.
    zenity --info --text "New hostname set to "$hostAnswer"."

else
    ## answer="no"
    RNDHOST=`egrep -i "^[^áéíÓÚàèìÒÙäëüÖÜãõñÃÕÑâêîÔÛ']{8}$" /usr/share/dict/words | shuf | tail -n 1`
    ##get a list of random words without accented characters that are 8chars long, shuffle them, and give us one.
    hostnamectl set-hostname $RNDHOST
    sudo sed -i '/127.0.0.1/c\127.0.0.1       localhost.localdomain   localhost '$RNDHOST'' /etc/hosts
    ##properly sets our new host in /etc/hosts file
    hostname $RNDHOST
    ##avoids need to reboot before showing our new hostname in terminals etc.
    zenity --info --text "New hostname set to "$RNDHOST".\nRun me again at any time to change your hostname again."
fi

else
    ##answer="no"
    zenity --error --text "Hostname not changed. Exiting!"
fi

    #++------------------- INSTALL ADITIONAL REPOSITORIES ------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW   Installing aditional repositories needed for Apps !!!   $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    echo -e "$YELLOW               ADITIONAL REPOSITORIES !!!              $COL_RESET"
    echo
    echo
sleep 2

    #++--------------------- INSTALL GRAPHICS DRIVER -----------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                  Graphics Card Drivers !!!                $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

Graphics=$( zenity --list --multiple --checklist\
    2>/dev/null --height=280 --width=500 \
    --title="Select items to Install"\
    --text="The following Software(s) will be Installed"\
    --ok-label "Install" --cancel-label "Skip"\
    --column "Pick" --column "Software(s)" --column "Description"\
    FALSE 		'ADM'			"AMD Radeon Open Source Drivers"\
    FALSE 		'INTEL'			"Intel iGPU Graphics Driver"\
    FALSE 		'NVIDIA 515'		"Nvidia Graphics drivers 515+"\
    FALSE 		'NVIDIA 470'		"Nvidia Graphics drivers 470"\
    FALSE 		'NVIDIA 390'		"Nvidia Graphics drivers 390"\
    FALSE 		'Vulkan-Libraries'	"Vulkan Libraries (RECOMENDED INSTALL)" );

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

    "NVIDIA 515")			#Nvidia Graphics drivers 515+
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses nvidia-glG06
    ;;

    "NVIDIA 470")			#Nvidia Graphics drivers 470 Series
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses nvidia-glG05
    ;;

    "NVIDIA 390")			#Nvidia Graphics drivers 390 Series
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses nvidia-glG04
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
    echo -e "$YELLOW*******************************************************************$COL_RESET"
    echo -e "$YELLOW   Update Kernel for GPU Otimizations and GPU PCI Passthrough !!!  $COL_RESET"
    echo -e "$YELLOW*******************************************************************$COL_RESET"
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
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1 intel_iommu=on iommu=pt rd.driver.pre=vfio-pci kvm.ignore_msrs=1/' /etc/default/grub
fi
if [[ "${CPU}" == "Intel Processor+ Radeon" ]]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& intel_iommu=on iommu=pt rd.driver.pre=vfio-pci/' /etc/default/grub
fi
if [[ "${CPU}" == "Intel Processor+ Radeon + Nvidia" ]]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1 intel_iommu=on iommu=pt rd.driver.pre=vfio-pci/' /etc/default/grub
fi
if [[ "${CPU}" == "AMD Processor + Nvidia" ]]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1 iommu=pt amd_iommu=on rd.driver.pre=vfio-pci/' /etc/default/grub
fi
if [[ "${CPU}" == "AMD Processor + Radeon" ]]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& iommu=pt amd_iommu=on rd.driver.pre=vfio-pci/' /etc/default/grub
fi
if [[ "${CPU}" == "AMD Processor + Radeon + Nvidia" ]]; then
    sudo sed -i 's/GRUB_CMDLINE_LINUX_DEFAULT="[^"]*/& nvidia-drm.modeset=1 iommu=pt amd_iommu=on rd.driver.pre=vfio-pci/' /etc/default/grub
fi

    #++------------------------------ SSD/HDD SWAP OPTIMIZATION -------------------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                   SSD/HDD SWAP OPTIMIZATION                 $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text="Optimize swap and swapness to reduze disk usage and improve performance and life time?"
if [ $? = 1 ]; then
    zenity --info --text="Swap has not changed"
else
    sudo touch /etc/sysctl.d/98-swap.conf
    echo "vm.swappiness=1" | sudo tee /etc/sysctl.d/98-swap.conf
    echo "vm.vfs_cache_pressure=50" | sudo tee -a /etc/sysctl.d/98-swap.conf
fi

    #++------------------------ INSTALL BRAVE BROWSER-------------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                 Brave Browser switcher !!!                $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text="Swap Firefox for Brave, a more secure and private browser based on chrome?\nYou can install Brave in the next steps if you want to keep Firefox"
if [ $? = 1 ]; then
    zenity --info --text="The firefox has been kept!"
else
    sudo systemctl stop packagekit
    sudo zypper rm -y firefox
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo zypper addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
    sudo zypper --non-interactive install brave-browser
fi

    #++------------------------------ INSTALL ONLYOFFICE -------------------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                   OnlyOffice switcher !!!                 $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text="Swap LibreOffice for OnlyOffice?"
if [ $? = 1 ]; then
    zenity --info --text="The LibreOffice has been kept!"
else
    sudo zypper rm -y libreoffice*
    sudo snap install onlyoffice-desktopeditors
fi

    #++---------------------- ENDING OF FIRST RUN OF SCRIPT -------------------++#

fi
    #++---------------------- INSTALL APPLICATION BUNDLE -------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW              Install Applications Bundle !!!              $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

Applications=$( zenity --list --multiple --checklist\
    2>/dev/null --height=720 --width=680\
    --title="Select items to Install"\
    --text="The following Software(s) will be Installed"\
    --ok-label "Install" --cancel-label "Skip"\
    --column "Pick" --column "Software(s)" 	--column "Description"\
    FALSE          'Authy'              "Two-factor authentication adds an additional layer of protection"\
    FALSE          'BalenaEtcher'		"Powerful utility for writing raw disk images & ISOs to USB keys"\
    FALSE          'Bottles'			"Environments to easily manage and run Windows apps on Linux"\
    FALSE          'Blueman'			"Is a Bluetooth manager with a modern interface"\
    FALSE          'Brave'		    	"Secure, Fast & Private Brave Browser with Adblocker"\
    FALSE          'ClamTk'		       	"Is the graphical interface of the open source antivirus ClamAV"\
    FALSE          'Discord'			"Talk, chat, hang out, and stay close with your friends"\
    FALSE          'Discord Tweks'		"Otimizations to Discord"\
    FALSE          'Flameshot'			"Cross-platform tool to take screenshots with many built-in features"\
    FALSE          'Git'                "A cli Fast, Scalable, Distributed Free & Open-Source VCS"\
    FALSE          'Github'             "GUI Open source Electron-based GitHub app"\
    FALSE          'Gparted'			"Free partition editor for graphically managing your disk partitions"\
    FALSE          'gThumb'             "Is an open-source software image viewer, image organizer"\
    FALSE          'Chrome'             "A cross-platform web browser by Google"\
    FALSE          'Kdenlive'			"Free, Open-source, Non-Linear Video Editor by KDE"\
    FALSE          'KeePassxc'			"Securely store passwords using industry standard encryption"\
    FALSE          'Mailspring'			"Mailspring is a new version of Nylas Mail"\
    FALSE          'Nemo'               "It is a lightweight and functional file manager with many features"\
    FALSE          'Neofetch'			"Is a command-line system information tool"\
    FALSE          'Notepadqq'			"A notepad++ clone for Linux loaded with functions and features"\
    FALSE          'OBS Studio'			"Capturing, compositing, recording, and streaming video content"\
    FALSE          'Peazip'             "Free file archiver utility, based on Open Source 7-Zip/p7zip"\
    FALSE          'QDirStat'			"Graphical application to show where your disk space has gone"\
    FALSE          'Signal'             "Signal - Private Messenger: Say Hello to Privacy"\
    FALSE          'Stacer'             "Linux System Optimizer & Monitoring"\
    FALSE          'Spotify'			"Spotify Music Player"\
    FALSE          'Imagewriter'		"A powerful OS image that copies images to drives byte by byte"\
    FALSE          'TeamViewer'			"Is without a doubt one of the best remote desktop software programs"\
    FALSE          'Telegram'			"System snapshots backup and restore tool for Linux"\
    FALSE          'Timeshift'			"Official Desktop Client for the Telegram Messenger"\
    FALSE          'ulauncher'			"Is a fast application launcher for Linux"\
    FALSE          'Virtualbox'			"Powerful virtualization product for enterprise as well as home use"\
    FALSE          'VLC'                "VLC Media Player"\
    FALSE          'Whatsapp'           "An unofficial WhatsApp desktop application for Linux"\
    FALSE          'WoeUSB-NG'          "Utility that enables you to create your own bootable Windows USB" );

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


    "Authy")                #Two-factor authentication adds an additional layer of protection beyond passwords
    sudo snap install authy
    sleep 5
    ;;

    "BalenaEtcher")			#Powerful utility for writing raw disk images & ISOs to USB keys
    curl -1sLf 'https://dl.cloudsmith.io/public/balena/etcher/setup.rpm.sh' | codename="tumbleweed" sudo -E bash
    sudo zypper --non-interactive install balena-etcher-electron
    sleep 10
    sudo sed -i '3 c Exec=/opt/balenaEtcher/balena-etcher-electron --no-sandbox %U' /usr/share/applications/balena-etcher-electron.desktop
    sleep 5
    ;;

    "Bottles")              #Uses environments to easily manage and run Windows apps on Linux
    sudo flatpak install flathub com.usebottles.bottles -y
    sleep 5
    ;;

    "Blueman")              #Is a Bluetooth manager with a modern interface
    sudo zypper --non-interactive install blueman
    sleep 5
    ;;

    "Brave")                #Brave Browser
    sudo rpm --import https://brave-browser-rpm-release.s3.brave.com/brave-core.asc
    sudo zypper addrepo --refresh https://brave-browser-rpm-release.s3.brave.com/x86_64/ brave-browser
    sudo zypper --non-interactive install brave-browser
    sleep 5
    ;;

    "ClamTk")               #Is the graphical interface of the open source antivirus ClamAV
    sudo flatpak install flathub com.gitlab.davem.ClamTk -y
    sleep 5
    ;;

    "Discord")              #Talk, chat, hang out, and stay close with your friends
    sudo zypper --non-interactive install discord
    sleep 5
    ;;

    "DiscordTweks")			#Otimizations to Discord
    sudo sed -i 's_Exec=/usr/bin/discord_Exec=/usr/bin/discord --no-sandbox --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy_gI' /usr/share/applications/discord.desktop
    sleep 5
    ;;

    "Flameshot")			#Cross-platform tool to take screenshots with many built-in features to save you time
    sudo sudo zypper --non-interactive install flameshot
    sleep 5
    ;;

    "git")                  #A fast, scalable, distributed free & open-source
    sudo sudo zypper --non-interactive install git
    sleep 5
    ;;

    "Github")               #Open source Electron-based GitHub app
    sudo rpm --import https://mirror.mwt.me/ghd/gpgkey
    sudo sh -c 'echo -e "[shiftkey]\nname=GitHub Desktop\nbaseurl=https://mirror.mwt.me/ghd/rpm\nenabled=1\ngpgcheck=0\nrepo_gpgcheck=1\ngpgkey=https://mirror.mwt.me/ghd/gpgkey" > /etc/zypp/repos.d/shiftkey-desktop.repo'
    sudo zypper ref && sudo zypper --non-interactive install github-desktop
    sleep 5
    ;;

    "Gparted")              #Is a free partition editor for graphically managing your disk partitions
    sudo zypper --non-interactive install gparted
    sleep 5
    ;;

    "gThumb")               #A free and open-source image viewer and image organizer with options to edit images
    sudo zypper --non-interactive install gthumb
    sleep 5
    ;;

    "Chrome")               #Google Chrome web browser
    sudo zypper ar http://dl.google.com/linux/chrome/rpm/stable/x86_64 Google-Chrome
    wget https://dl.google.com/linux/linux_signing_key.pub -P /tmp/
    sudo rpm --import /tmp/linux_signing_key.pub
    sudo zypper ref
    sudo zypper --non-interactive install google-chrome-stable
    sleep 5
    ;;

    "Kdenlive")             #Free, Open-source, Non-Linear Video Editor by KDE
    sudo zypper --non-interactive install kdenlive
    sleep 5
    ;;

    "KeePassxc")			#Securely store passwords using industry standard encryption
    sudo snap install keepassxc
    sleep 5
    ;;

    "Mailspring")			#Mailspring Mail Client
    sudo snap install mailspring
    sleep 5
    ;;

    "Nemo")                 #It is a lightweight and functional file manager with many features
    sudo zypper --non-interactive install nemo
    sleep 5
    ;;

    "Neofetch")             #Is a command-line system information tool
    sudo zypper --non-interactive install neofetch
    sleep 5
    ;;

    "Notepadqq")			#A notepad++ clone for Linux loaded with functions and features
    sudo zypper --non-interactive install notepadqq
    sleep 5
    ;;

    "OBS Studio")			#Designed for capturing, compositing, encoding, recording, and streaming video content
    sudo flatpak install flathub com.obsproject.Studio -y
    sleep 5
    ;;

    "Peazip")               #Free file archiver utility, based on Open Source technologies of 7-Zip/p7zip
    sudo zypper --non-interactive install peazip
    sleep 5
    ;;

    "QDirStat")             #Graphical application to show where your disk space has gone, help you to clean it up
    sudo zypper --non-interactive install qdirstat
    sleep 5
    ;;

    "Signal")               #Signal - Private Messenger: Say Hello to Privacy
    sudo snap install signal-desktop
    sleep 5
    ;;

    "Stacer")               #Stacer Linux Optimizer & Monitoring
    curl -s https://api.github.com/repos/oguzhaninan/Stacer/releases/latest | grep browser_download_url | grep '[.]rpm' | head -n 1 | cut -d '"' -f 4 | wget --base=http://github.com/ -i - -O /tmp/stacer.rpm
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses /tmp/stacer.rpm
    sleep 5
    ;;

    "Spotify")              #Spotify Music Player
    sudo snap install spotify
    sleep 5
    ;;

    "Imagewriter")			#A powerful OS image that copies images to drives byte by byte
    sudo zypper --non-interactive install imagewriter
    sleep 5
    ;;

    "TeamViewer")			#Is without a doubt one of the best remote desktop software programs
    wget https://download.teamviewer.com/download/linux/teamviewer-suse.x86_64.rpm -P /tmp/
    sudo zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys install --auto-agree-with-licenses /tmp/teamviewer-suse.x86_64.rpm
    sleep 5
    ;;

    "Telegram")             #Official Desktop Client for the Telegram Messenger
    sudo zypper --non-interactive install telegram-desktop
    sleep 5
    ;;

    "Timeshift")			#System snapshots backup and restore tool for Linux
    sudo zypper --non-interactive install timeshift
    sleep 5
    ;;

    "ulauncher")			#Is a fast application launcher for Linux
    sudo zypper --non-interactive install ulauncher
    sleep 5
    ;;

    "Virtualbox")			#Powerful x86 and AMD64/Intel64 virtualization product for enterprise as well as home use
    sudo zypper --non-interactive install virtualbox
    sleep 5
    sudo gpasswd -a $USER vboxusers
    sleep 2
    ;;

    "VLC")                  #VLC Media Player
    sudo zypper --non-interactive install vlc
    sleep 5
    ;;

    "Whatsapp")            #An unofficial WhatsApp desktop application for Linux
    sudo snap install whatsapp-for-linux
    sleep 5
    ;;

    "WoeUSB-NG")            #Utility that enables you to create your own bootable Windows USB
    sudo zypper --non-interactive install woeusb-ng
    sleep 5
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

    #++---------------------------- INSTALL GAMES SOFTWARES ---------------------------++#
    clear
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                 Install Games Softwares !!!                $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

Games=$( zenity --list --multiple --checklist\
    2>/dev/null --height=450 --width=650\
    --title="Select items to Install"\
    --text="The following Software(s) will be Installed"\
    --ok-label "Install" --cancel-label "Skip"\
    --column "Pick" --column "Software(s)" 	--column "Description"\
    FALSE          'AntimicroX'			"Used to map gamepad keys to keyboard, mouse, scripts and macros"\
    FALSE          'Ludusavi'			"A tool for backing up your PC video game save data"\
    FALSE          'GameHub'			"Supports non-native games as well as native games for Linux"\
    FALSE          'Gamemode'			"Allows games to request a set of optimisations for a games process"\
    FALSE          'Gamescope'			"Allows for games to run in an isolated Xwayland instance"\
    FALSE          'MangoHud'			"A Vulkan and OpenGL overlay for monitoring FPS, temp, CPU/GPU..."\
    FALSE          'vkBasalt'			"Vulkan post processing layer to enhance the visual graphics of games"\
    FALSE          'GOverlay'			"A Graphical UI to help manage Linux monitoring overlays"\
    FALSE          'HeroicLauncher'		"Open Source Game Launcher for Epic and GOG"\
    FALSE          'ProtonUP'			"Install and manage Custom Proton's for Steam and Wine-GE for Lutris"\
    FALSE          'Lutris'             "Play all your games on Linux"\
    FALSE          'Steam'              "Is a digital game distribution platform for computers" );

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
    sleep 5
    ;;

    "Ludusavi")             #A tool for backing up your PC video game save data
    sudo flatpak install flathub com.github.mtkennerly.ludusavi -y
    sleep 5
    ;;

    "GameHub")  			#Supports non-native games as well as native games for Linux
    curl -s https://api.github.com/repos/tkashkin/GameHub/releases/latest | grep browser_download_url | grep '[.]flatpak' | head -n 1 | cut -d '"' -f 4 | wget --base=http://github.com/ -i - -O /tmp/GameHub.flatpak
    sudo flatpak install /tmp/GameHub.flatpak -y
    sleep 5
    ;;

    "Gamemode")             #Allows games to request a set of optimisations to be apply a game process
    sudo zypper --non-interactive install gamemoded libgamemode0 libgamemode0-32bit
    sleep 5
    ;;

    "Gamescope")            #Allows for games to run in an isolated Xwayland instance
    sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/home:darix:valve/openSUSE_Tumbleweed/home:darix:valve.repo
    sudo zypper --gpg-auto-import-keys refresh
    sudo zypper --non-interactive install gamescope
    sleep 5
    ;;

    "MangoHud")             #A Vulkan and OpenGL overlay for monitoring FPS, temp, CPU/GPU and more
    sudo zypper --non-interactive install mangohud
    sleep 5
    ;;

    "vkBasalt")             #A Vulkan post processing layer to enhance the visual graphics of games
    sudo zypper --non-interactive install vkbasalt
    sleep 5
    ;;

    "GOverlay")             #A Graphical UI to help manage Linux monitoring overlays
    sudo zypper --non-interactive install vulkan-tools
    sudo zypper --non-interactive install goverlay
    sleep 5
    ;;

    "HeroicLauncher")       #Open Source Game Launcher for Epic and GOG
    sudo flatpak install flathub com.heroicgameslauncher.hgl -y
    sleep 5
    ;;

    "ProtonUP")             #Install and manage Custom Proton's for Steam and Wine-GE for Lutris
    sudo flatpak install flathub net.davidotek.pupgui2 -y
    sleep 5
    ;;

    "Lutris")             #Play all your games on Linux
    sudo zypper --non-interactive install lutris
    sleep 5
    ;;

    "Steam")				#Is a digital game distribution platform for computers
    sudo zypper --non-interactive install steam
    sleep 5
    ;;

    esac
done
	)| zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Installing Games Softwares(s)" 2>/dev/null
fi

unset IFS

if [[ ! -z $Games ]]; then
    Title=$1
    Text=$2
    echo
    echo
    echo -e "$YELLOW   Complete! Selecteds Games Softwares Installed !!!   $COL_RESET"
    echo
    echo

fi

    #++------------------------- BONUS INSTALL-----------------------++#
    echo
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo -e "$YELLOW                Itch.io Bonus Installation !!!             $COL_RESET"
    echo -e "$YELLOW***********************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text="Would you like to install Itch.io, the best indie gaming platform?"
if [ $? = 0 ]; then
    wget --user-agent=Linux --content-disposition -E -c https://itch.io/app/download -P /tmp/ && chmod +x /tmp/itch-setup
    /tmp/./itch-setup
    sudo mv ~/.itch /opt/itch
    sudo mv ~/.local/share/applications/io.itch.itch.desktop /usr/share/applications/io.itch.itch.desktop
    sudo sed -i '4 c TryExec=/opt/itch/itch' /usr/share/applications/io.itch.itch.desktop
    sudo sed -i '5 c Exec=/opt/itch/itch --no-sandbox %U' /usr/share/applications/io.itch.itch.desktop
    sudo sed -i '6 c Icon=/opt/itch/icon.png' /usr/share/applications/io.itch.itch.desktop
    sudo sed -i '2 c /opt/itch/app-25.5.1/itch --no-sandbox --prefer-launch --appname itch -- "$@"' /opt/itch/itch
    sleep 10
fi


    #++--------------------- Remove user from sudoers ---------------------++#
    echo -e "$BLUE***********************************************************$COL_RESET"
    echo -e "$BLUE                 Remove user from sudoers !!!              $COL_RESET"
    echo -e "$BLUE***********************************************************$COL_RESET"
    sleep 2
    sudo usermod -rG wheel $(whoami)

    #++--------------------------- Cleaning temp --------------------------++#
    echo -e "$BLUE***********************************************************$COL_RESET"
    echo -e "$BLUE                Cleaning temporary files !!!               $COL_RESET"
    echo -e "$BLUE***********************************************************$COL_RESET"
    sleep 2
    sudo rm -rf /tmp/*.*

    #++--------------------------- SCRIPT END -----------------------------++#
    echo
    echo -e "$GREEN Done...$COL_RESET"
    sleep 2
    echo
    echo
    clear
    echo
    echo -e "$GREEN***********************************************************$COL_RESET"
    echo -e "$GREEN             MaxxedSUSE Install Script v0.1                $COL_RESET"
    echo -e "$GREEN                        Finish !!!                         $COL_RESET"
    echo -e "$GREEN***********************************************************$COL_RESET"
    echo
    echo
    echo
    echo -e "$CYAN      All contributions to this project are welcome.       $COL_RESET"
    echo
    echo -e "$CYAN   Clone this repo, make your changes and pull request.    $COL_RESET"
    echo
    echo
    clear
    echo
    echo -e "$RED************************************************************$COL_RESET"
    echo -e "$RED      WEE MUST REBOOT NOW  TO FINALIZE INSTALLATION !!!     $COL_RESET"
    echo -e "$RED************************************************************$COL_RESET"
    echo -e "$RED Check for updates at https://github.com/Jonatas-Goncalves  $COL_RESET"
    echo -e "$RED                 Thanks for use my script!                  $COL_RESET"
    echo -e "$RED                   Good Work or Playing!                    $COL_RESET"
    echo -e "$RED************************************************************$COL_RESET"
    sleep 10
    echo
    sudo reboot

