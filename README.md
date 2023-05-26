# MaxxedSUSE

This project is a script to install main and most common day-to-day applications of a common Windows user and  too to facilitate the installation of games for those who are not familiar with Linux.

    * --- This Script is to run on a clean install of OpenSUSE Leap 15.5 or Tumbleweed --- *

# Installation

    Run directly from web with this command: 

    for KDE on Leap run:
    curl -L https://raw.githubusercontent.com/Jonatas-Goncalves/MaxxedSUSE/main/MaxxedSUSE-KDE-Leap.sh | sudo -sE bash
    For KDE on Tumbleweed run:
    curl -L https://raw.githubusercontent.com/Jonatas-Goncalves/MaxxedSUSE/main/MaxxedSUSE-KDE-Tumbleweed.sh | sudo -sE bash
    
    **Will be added soon**
    for GNOME run:
    curl -L https://raw.githubusercontent.com/Jonatas-Goncalves/MaxxedSUSE/main/MaxxedSUSE-GNOME.sh | sudo -sE bash

    or
    Download the zip, extract, and "sudo bash MaxxedSUSE-XXX-XXX.sh"



# Description
This project is intended for those migrating from Windows to Linux who are generally unfamiliar with Linux distributions and looking for a fast and stable system to work, play or both, so they don't have to spend hours reading tutorials to find out. how to install the day-to-day software and that in a simple way leave the system ready for use.

That's why I created just one script to be used with just one command line, for those who don't know how to use the terminal and are not familiar with Unix systems it makes a total difference to use just one command, but I am fully aware that it could have been divided into several sections and different files in order to be more organized and optimized, however it would require more user actions and that's exactly what I want to avoid with this project.

If you don't want games, nothing will be installed over games, which is completely under the user's control.

It is a one-page script to be of simple conference to the user, not needing to consult an immensity of source code to trust or not in the execution, just checking the changes that will be carried out in just one page of easy conference and understanding, obviously that there's still a lot to simplify in this script.

OpenSUSE Leap 15.5 / Tumbleweed:
The choice of OpenSUSE was based on several tests that I performed on many distributions, and Opensuse in my opinion (I know it's completely questionable) is the most stable, safe and with the best performance, both in games and in general system performance for open applications and perform daily tasks.
In particular, I noticed that in Wine the performance is much superior to other distributions, due to Opensuse always delivering the latest updates, it makes the system fluids impeccable, With better results on Tumbleweed for being Rolling Release!
In tests that I carried out in games via Wine, they showed a much higher margin than other distros focused on games such as Nobara Project and winesapOS, I used these two distros in particular as an example because both have several modifications aimed at Games, especially via Wine, modifications that for the most part, Opensuse dispenses with these fixes already applied in the most recent updates.
Another factor is that for me Opensuse has become an "unbreakable" system, even if it's Rolling Release in the case of Tumbleweed, because with the use of Snapper (already integrated into the system) I can revert the slightest changes to the system without difficulty, not to mention the possibility of using Timeshift for full system backups to be facilitated by using standard BTRFS formatting.

My work here consisted of small modifications for compatibility of Nvidia drivers, PCI Passthroug for those who use Virtual Machine and adaptations in the interface such as standard Windows shortcuts to open common applications and some small additions of startup parameters for some applications.

Now about the Script:
I tried to make the tasks of installing basic applications from a Windows Desktop simple and not very confusing, and as selective as possible to let the user choose properly what type of applications he would like to use, the focus here is not to use a modified image of the system so that the user can have the confidence of a Opensuse stable and Rolling Release system straight from the original source without modifications and without having to check everything that has been modified, he can make a simple and uncomplicated conference in the script code to see exactly what is being installed and choose not to make changes you don't want or remove and add others you don't want.
I am fully aware that this script needs to be improved, reduced and simplified, but I am a beginner in Shell Script. Any contribution to this project will be welcome.


What system modifications does the MaxxedSUSE Script perform?

Opensuse 15.5:

    Added repositories:

    Exclusive MaxxedSUSE repository to bring some useful tools to Leap 15.4:
    https://download.opensuse.org/repositories/home:/MaxxedSUSE/15.5/ MaxxedSUSE

    https://download.opensuse.org/repositories/Emulators:/Wine/15.5/ Wine
    https://download.nvidia.com/opensuse/leap/$releasever' NVIDIA
    https://mirrorcache-us.opensuse.org/repositories/system:/snappy/openSUSE_Leap_15.5/ snappy
    http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_15.5/ packman
    
Opensuse Tumbleweed:

    Added repositories:

    Exclusive MaxxedSUSE repository to bring some useful tools to Tumbleweed:
    https://download.opensuse.org/repositories/home:/MaxxedSUSE/openSUSE_Tumbleweed

    https://download.nvidia.com/opensuse/tumbleweed NVIDIA
    https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
    https://mirrorcache-us.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ Wine
    http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman



Some kernel modules loaded for better Nvidia driver operation and to enable PCI Passthrough.
added depending on the processor options selected during script execution:
    
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


### ****** End of system changes. ****

**GNOME SCRIPT WILL BE ADDED SOON**


- All other modifications or installations are done at the user's discretion during the script.

<!--🖼️OCTOCAT-->
<!--📊STATSGRAPH / 🌐WEBSITE: https://github.com/anuraghazra/github-readme-stats -->
<p align="center">
<img src="https://github-readme-stats.vercel.app/api?username=Jonatas-Goncalves&show_icons=true&theme=merko"><img src="https://github-readme-streak-stats.herokuapp.com?user=Jonatas-Goncalves&theme=merko&date_format=M%20j%5B%2C%20Y%5D">
<!--📙LANGUAGES / 🌐WEBSITE: https://github.com/anuraghazra/github-readme-stats -->
<p align="center">
<img src="https://github-readme-stats.vercel.app/api/top-langs/?username=Jonatas-Goncalves&layout=compact&theme=merko">
<!--📛BADGES / 🌐WEBSITE: https://github.com/DenverCoder1/custom-icon-badges -->
<p align="center">
  <a href="https://github.com/Jonatas-Goncalves?tab=repositories&sort=stargazers">
    <img alt="total stars" title="Total stars on GitHub" src="https://custom-icon-badges.herokuapp.com/badge/dynamic/json?logo=star&color=55960c&labelColor=488207&label=Stars&style=for-the-badge&query=%24.stars&url=https://api.github-star-counter.workers.dev/user/Jonatas-Goncalves"/></a><a href="https://github.com/Jonatas-Goncalves?tab=followers"><a href="https://github.com/Jonatas-Goncalves?tab=followers">
    <img alt="followers" title="Follow me on Github" src="https://custom-icon-badges.herokuapp.com/github/followers/Jonatas-Goncalves?color=23960c&labelColor=188207&style=for-the-badge&logo=person-add&label=Followers&logoColor=white"/></a>
<!--👀VIEWS / 🌐WEBSITE: https://github.com/antonkomarev/github-profile-views-counter -->
<p align="center">
<img src="https://komarev.com/ghpvc/?username=Jonatas-Goncalves&color=0E9C47&style=for-the-badge">



Best regards, Jonatas Gonçalves

Twitter:: https://twitter.com/jsougoncalves


GPLv3
