#!/bin/bash

#Inclusion of Essential Scripts
source ./Scripts/Functions/Find.sh
FIND /Scripts/Functions/ Functions.sh
FIND /Scripts/Functions/ Zypper.sh

# check if zenity is installed
CHECK_DEPENDS_ELSE_INSTALL

# run only if a superuser
if [[ $EUID -ne 0 ]]; then
	IF_NOT_SUPERUSER $(basename "$0")
   	exit 1
else

#!/bin/bash

    #++---------------------------'HOSTNAME CHANGER'------------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                              HOSTNAME CHANGER !!!                                            $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

zenity --question --text "Hostname Changer! \n This script helps you set your hostname. \n Do you wish to proceed?" --height=80 --width=300
    rc=$?

    if [ "${rc}" == "0" ]; then
        ## answer="yes"
        zenity --question --text "Do you want to provide a hostname? \n(Otherwise we'll generate a cool random one for you)" --height=80 --width=350
        rc=$?

    if [ "${rc}" == "0" ]; then
        ## answer="yes"
        hostAnswer=$(zenity --entry --text "What hostname would you like?" --entry-text "localhost" --height=80 --width=300)
        hostnamectl set-hostname $hostAnswer
        sudo sed -i '/127.0.0.1/c\127.0.0.1       localhost.localdomain   localhost '$hostAnswer'' /etc/hosts
        ##properly sets our new host in /etc/hosts file
        hostname $hostAnswer
        ##avoids need to reboot before showing our new hostname in terminals etc.
        zenity --info --text "New hostname set to "$hostAnswer"." --height=80 --width=300

    else
        ## answer="no"
        RNDHOST=`egrep -i "^[^áéíÓÚàèìÒÙäëüÖÜãõñÃÕÑâêîÔÛ']{8}$" /usr/share/dict/words | shuf | tail -n 1`
        ##get a list of random words without accented characters that are 8chars long, shuffle them, and give us one.
        hostnamectl set-hostname $RNDHOST
        sudo sed -i '/127.0.0.1/c\127.0.0.1       localhost.localdomain   localhost '$RNDHOST'' /etc/hosts
        ##properly sets our new host in /etc/hosts file
        hostname $RNDHOST
        ##avoids need to reboot before showing our new hostname in terminals etc.
        zenity --info --text "New hostname set to "$RNDHOST".\nRun me again at any time to change your hostname again." --height=80 --width=300
    fi

    else
        ##answer="no"
        zenity --error --text "Hostname not changed. Exiting!" --height=80 --width=300
    fi
    echo
    echo
    echo DONE!!



    #++--------------------- INSTALL GRAPHICS DRIVER -----------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                                           Graphics Card Drivers !!!                                          $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

Graphics=$( zenity --list --multiple --checklist\
    2>/dev/null --height=500 --width=600 \
    --title="Select items to Install"\
    --text="SELECT YOUR GRAPHICS CARD"\
    --ok-label "Install" --cancel-label "Skip"\
    --column "Pick" --column "Software(s)" --column "Description"\
    FALSE 		'AMD'               "AMD Radeon Open Source Drivers"\
    FALSE 		'INTEL'             "Intel iGPU Graphics Driver"\
    FALSE 		'NVIDIA 550+'        "Nvidia Graphics drivers 550+"\
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
    ZYPPER_INSTALL kernel-firmware-amdgpu libdrm_amdgpu1 libdrm_amdgpu1-32bit libdrm_radeon1 libdrm_radeon1-32bit libvulkan_radeon libvulkan_radeon-32bit libvulkan1 libvulkan1-32bit
    ;;

    "INTEL")			#Intel iGPU Graphics Driver
    ZYPPER_INSTALL --no-recommends kernel-firmware-intel libdrm_intel1 libdrm_intel1-32bit libvulkan1 libvulkan1-32bit libz1-32bit libvulkan_intel libvulkan_intel-32bit
    ;;

    "NVIDIA 550")			#Nvidia Graphics drivers 550+
    sudo sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf'
    ZYPPER_INSTALL ffnvcodec-devel kernel-firmware-nvidia nvidia-compute-G06 nvidia-compute-G06-32bit nvidia-compute-utils-G06 nvidia-driver-G06-kmp-default nvidia-drivers-G06 nvidia-gl-G06 nvidia-gl-G06-32bit nvidia-utils-G06 nvidia-video-G06 nvidia-video-G06-32bit
    ;;

    "NVIDIA 470")			#Nvidia Graphics drivers 470 Series
    sudo sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf'
    ZYPPER_INSTALL nvidia-computeG05 nvidia-computeG05-32bit nvidia-gfxG05-kmp-default nvidia-glG05 nvidia-glG05-32bit x11-video-nvidiaG05 x11-video-nvidiaG05-32bit
    ;;

    "NVIDIA 390")			#Nvidia Graphics drivers 390 Series
    sudo sh -c 'echo "blacklist nouveau" >> /etc/modprobe.d/blacklist.conf'
    ZYPPER_INSTALL nvidia-computeG04 nvidia-computeG04-32bit nvidia-gfxG04-kmp-default nvidia-glG04 nvidia-glG04-32bit x11-video-nvidiaG04 x11-video-nvidiaG04-32bit
    ;;

    "Vulkan-Libraries")			#Vulkan Libraries (RECOMENDED INSTALL)
    sudo zypper --non-interactive --no-gpg-checks install --auto-agree-with-licenses libvulkan1 libvulkan1-32bit
    ;;

    esac
    done
    ) | zenity --progress --auto-close --width=720 --pulsate --no-cancel --title "Installing Drivers" 2>/dev/null
    fi

    unset IFS
    echo
    echo
    echo DONE!!

    #++---------------------- CONFIGURE KERNEL FOR CPU ---------------------++#
    echo
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo -e "$YELLOW                        Update Kernel for GPU Otimizations and GPU PCI Passthrough !!!                        $COL_RESET"
    echo -e "$YELLOW**************************************************************************************************************$COL_RESET"
    echo
    sleep 2

# Detect the openSUSE version
    OPEN_SUSE_VERSION=$(cat /etc/os-release | grep '^VERSION_ID=' | cut -d '"' -f 2)

# Select CPU using Zenity
CPU=$(zenity --list --title "SELECT YOUR CPU." --text "IF YOU WANT GPU PASSTHROUGH SELECT YOUR HARDWARE, OR SKIP" \
    --radiolist \
    --column "Select" \
    --column "CPU Model" \
    --height=500 --width=400 \
    --cancel-label "Skip"\
    FALSE "Intel Processor + Nvidia" \
    FALSE "Intel Processor+ Radeon" \
    FALSE "Intel Processor+ Radeon + Nvidia" \
    FALSE "AMD Processor + Nvidia" \
    FALSE "AMD Processor + Radeon" \
    FALSE "AMD Processor + Radeon + Nvidia" );

# Configure Grub based on CPU selection and openSUSE version
case "${CPU}" in
    "Intel Processor + Nvidia")
        sed_command='nvidia-drm.modeset=1 rd.driver.blacklist=nouveau intel_iommu=on iommu=pt rd.driver.pre=vfio-pci kvm.ignore_msrs=1'
        ;;
    "Intel Processor+ Radeon")
        sed_command='intel_iommu=on iommu=pt rd.driver.pre=vfio-pci'
        ;;
    "Intel Processor+ Radeon + Nvidia")
        sed_command='nvidia-drm.modeset=1 rd.driver.blacklist=nouveau intel_iommu=on iommu=pt rd.driver.pre=vfio-pci'
        ;;
    "AMD Processor + Nvidia")
        sed_command='nvidia-drm.modeset=1 rd.driver.blacklist=nouveau iommu=pt amd_iommu=on rd.driver.pre=vfio-pci'
        ;;
    "AMD Processor + Radeon")
        sed_command='iommu=pt amd_iommu=on rd.driver.pre=vfio-pci'
        ;;
    "AMD Processor + Radeon + Nvidia")
        sed_command='nvidia-drm.modeset=1 rd.driver.blacklist=nouveau iommu=pt amd_iommu=on rd.driver.pre=vfio-pci'
        ;;
    *)
        echo "Skipping Grub configuration."
        ;;
esac

# Apply Grub configuration if CPU is selected
if [ -n "${sed_command}" ]; then
    sudo sed -i "s/GRUB_CMDLINE_LINUX_DEFAULT=\"[^\"]*/& ${sed_command}/" /etc/default/grub
    sudo grub2-mkconfig -o /boot/grub2/grub.cfg
    OPEN_SUSE_VERSION=$(cat /etc/os-release | grep '^ID=')

    # Check if NVIDIA drivers are used and execute appropriate commands
    if [ "${use_nvidia_drivers}" = true ]; then
        sudo mv /boot/initrd-$(uname -r) /boot/initrd-$(uname -r)-nouveau
    fi

    # Check openSUSE version and execute appropriate commands
    if [[ "${OPEN_SUSE_VERSION}" == "opensuse-leap" ]]; then
        sudo mkinitrd /boot/initrd-$(uname -r) $(uname -r)
    elif [[ "${OPEN_SUSE_VERSION}" == "opensuse-tumbleweed" ]]; then
        sudo dracut -f --regenerate-all
    else
        echo "Unsupported openSUSE version."
    fi

    echo "DONE!!"
else
    echo "No CPU selected. Skipping Grub configuration."
fi

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
    echo
    echo
    echo DONE!!

    #++---------------------- ENDING OF FIRST RUN OF SCRIPT -------------------++#

fi

source ./Start.sh
