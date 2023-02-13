# MaxxedSUSE

This project is a script for the main and most common day-to-day applications of a common Windows user and to facilitate the installation of games for those who are not familiar with Linux.

    * --- This Script is to run on a clean install of OpenSUSE Leap 15.3, 15.4 or Tumbleweed --- *

# Installation

    Run directly from web with this command: 

    for KDE run:
    curl -L https://raw.githubusercontent.com/Jonatas-Goncalves/MaxxedSUSE/main/MaxxedSUSE-KDE.sh | bash
    
    **Will be added soon**
    for GNOME run:
    curl -L https://raw.githubusercontent.com/Jonatas-Goncalves/MaxxedSUSE/main/MaxxedSUSE-GNOME.sh | bash

    or
    Download the zip, extract, and "sudo bash MaxxedSUSE-XXX.sh"



# Description
This project aims to be for those who in general are not familiar with Linux distributions and looking for a fast and stable system to work, to play or both, without having to spend hours figuring out how to install this or here. And that's why the use of just a Script, mostly optional to the user, if you don't want games, nothing will be installed about games, being totally under the user's control.

It is a one-page script to be of simple conference to the user, not needing to consult an immensity of source code to trust or not in the execution, just checking the changes that will be carried out in just one page of easy conference and understanding, obviously that there's still a lot to simplify in this script.

OpenSUSE Leap 15.3 / 15.4 / Tumbleweed:
The choice of OpenSUSE was based on several tests that I performed on many distributions, and Opensuse in my opinion (I know it's completely questionable) is the most stable, safe and with the best performance, both in games and in general system performance for open applications and perform daily tasks.
In particular, I noticed that in Wine the performance is much superior to other distributions, due to Opensuse always delivering the latest updates, it makes the system fluids impeccable, With better results on Tumbleweed for being Rolling Release!
In tests that I carried out in games via Wine, they showed a much higher margin than other distros focused on games such as Nobara Project and winesapOS, I used these two distros in particular as an example because both have several modifications aimed at Games, especially via Wine, modifications that for the most part, Opensuse dispenses with these fixes already applied in the most recent updates.
Another factor is that for me Opensuse has become an "unbreakable" system, even if it's Rolling Release in the case of Tumbleweed, because with the use of Snapper (already integrated into the system) I can revert the slightest changes to the system without difficulty, not to mention the possibility of using Timeshift for full system backups to be facilitated by using standard BTRFS formatting.

My work here consisted of small modifications for compatibility of Nvidia drivers, PCI Passthroug for those who use Virtual Machine and adaptations in the interface such as standard Windows shortcuts to open common applications and some small additions of startup parameters for some applications.

Now about the Script:
I tried to make the tasks of installing basic applications from a Windows Desktop simple and not very confusing, and as selective as possible to let the user choose properly what type of applications he would like to use, the focus here is not to use a modified image of the system so that the user can have the confidence of a Opensuse stable and Rolling Release system straight from the original source without modifications and without having to check everything that has been modified, he can make a simple and uncomplicated conference in the script code to see exactly what is being installed and choose not to make changes you don't want or remove and add others you don't want.
I am fully aware that this script needs to be improved, reduced and simplified, but I am a beginner in Shell Script. Any contribution to this project will be welcome.


What system modifications does the MaxxedSUSE Script perform?

Opensuse 15.3 / 15.4:

    Added repositories:
    https://download.nvidia.com/opensuse/leap/15.4/' NVIDIA
    https://download.opensuse.org/repositories/home:Dead_Mozay/15.4/ Dead_Mozay
    https://download.opensuse.org/repositories/home:/munix9/15.4/ munix9
    https://download.opensuse.org/repositories/home:/munix9:/test/15.4/ munix9:test
    https://download.opensuse.org/repositories/system:/snappy/openSUSE_Leap_15.4/ snappy
    https://download.opensuse.org/repositories/home:/jason-kurzik/15.4/ jason-kurzik
    https://download.opensuse.org/repositories/home:darix:valve/openSUSE_Tumbleweed/home:darix:valve.repo
    http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_15.4/ packman
    
Opensuse Tumbleweed:

   added repositories:
    https://download.nvidia.com/opensuse/tumbleweed NVIDIA
    https://download.opensuse.org/repositories/mozilla/openSUSE_Tumbleweed/ Mozzila
    https://download.opensuse.org/repositories/openSUSE:/Tumbleweed/standard/ openSUSE:Tumbleweed
    https://download.opensuse.org/repositories/openSUSE:/Factory:/NonFree/standard/
    https://download.opensuse.org/repositories/home:/munix9/openSUSE_Tumbleweed/ munix9
    https://download.opensuse.org/repositories/home:/munix9:/test/openSUSE_Tumbleweed/ munix9:test
    https://download.opensuse.org/repositories/home:Dead_Mozay/openSUSE_Tumbleweed/ Dead_Mozay
    https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
    https://download.opensuse.org/repositories/home:jason-kurzik/openSUSE_Tumbleweed/ jason-kurzik
    http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
    

Some kernel modules loaded for better Nvidia driver operation and to enable PCI Passthrough, added depending on the processor options selected during script execution:
    
    nvidia-drm.modeset=1
    intel_iommu=on
    amd_iommu=on
    iommu=en rd.driver.pre=vfio-pci

Snap daemon configuration to allow installation of Snaps.

    zypper --non-interactive dup --from snappy
    zypper --non-interactive install snapd
    systemctl enable --now snapd
    systemctl enable --now snapd.apparmor
    systemctl start snapd.apparmor
    systemctl start snapd

Initial flathub setup to allow flatpak installations:

    flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo


Added parameters to launch some applications:

    Discord:

    --no-sandbox --ignore-gpu-blocklist --disable-features=UseOzonePlatform --enable-features=VaapiVideoDecoder --use-gl=desktop --enable-gpu-rasterization --enable-zero-copy

    Balena Etcher:

     --no-sandbox

    Itch.io:

    --no-sandbox
    
    atom:
    --in-process-gpu


**GNOME SCRIPT WILL BE ADDED SOON**
Changing keyboard shortcuts to standard Windows using the gsetings command for those using gnome:


    Disable gnome-screenshot to release the [print] key to be configured in any app:
    gsettings set org.gnome.shell.keybindings show-screenshot-ui ["''"]
    gsettings reset org.gnome.shell.keybindings screenshot "''"]

    Open up file browser:
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom1/ binding "<Super>E"

    Launch Terminal:
    gsettings set org.gnome.settings-daemon.plugins.media-keys.custom-keybinding:/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom2/ binding "<Control><Alt>t "

    Show Desktop:
    gsettings set org.gnome.desktop.wm.keybindings show-desktop "['<Super>D']"

    Switch Applications:
    gsettings set org.gnome.desktop.wm.keybindings switch-applications "['<Alt>Tab']"

Switch Applications Backward

    gsettings set org.gnome.desktop.wm.keybindings switch-applications-backward "['<Shift><Alt>Tab']"
    
Extensions Addeded (User selected)

    AppIndicator and KStatusNotifierItem == Adds AppIndicator, KStatusNotifierItem and legacy Tray icons support to the Shell
    Application Volume Mixer == Control volume output per-application
    ArcMenu == Application menu for GNOME Shell
    Blur my Shell == Adds a blur look to different parts of the GNOME Shell, including the top panel, dash and overview
    Clipboard History == A extension that saves items you've copied into an easily accessible, searchable history panel.
    Cafeine == Disable the screensaver and auto suspend
    Dash to Panel == Moves the dash into the gnome main panel so that the application launchers and system tray are combined into a single panel
    Desktop Icons: Neo == This adds desktop icons to GNOME
    Emoji Selector == This extension provides a parametrable popup menu displaying most emojis, clicking on an emoji copies it to the clipboard
    GSConnect == Is a complete implementation of KDE Connect especially for GNOME Shell with Nautilus, Chrome and Firefox integration
    Impatience == Speed up the gnome-shell animation speed
    Soud Input & Output Device Chooser == Shows a list of sound output and input devices in the status menu below the volume slider
    Start Overlay in Application View == When activating overview (Super button), the application view is shown instead of the view with the windows.
    Vitals == A one stop shop to monitor your computer&apos;s temperature, voltage, fan speed, memory usage, processor load, system resources, network speed, storage stats and battery health.
    Pop Shell == A keyboard-driven layer for GNOME Shell which allows for quick and sensible navigation and management of windows
    


### ****** End of system changes. ****



- All other modifications or installations are done at the user's discretion during the script.



Best regards, Jonatas Gonçalves

Twitter:: https://twitter.com/jsougoncalves


GPLv3
