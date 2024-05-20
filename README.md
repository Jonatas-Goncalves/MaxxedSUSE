# MaxxedSUSE

This project is a script to install main and most common day-to-day applications of a common Windows user and also to facilitate the installation of Applications, Tools and Games for those who are not familiar with Linux.

    * --- This Script is to run on a clean install of OpenSUSE Leap 15.6 and Tumbleweed (Possibly works in 15.5)--- *

# Installation

    Run directly from terminal with this command:

    curl -L https://raw.githubusercontent.com/Jonatas-Goncalves/MaxxedSUSE/main/MaxxedSUSE.sh | bash

    or
    Download the zip, extract, and "sudo -sE bash Start.sh"



# Description
This project is intended for those migrating from Windows to Linux who are generally unfamiliar with Linux distributions and looking for a fast and stable system to work, play or both, so they don't have to spend hours reading tutorials to find out how to install the day-to-day software and that in a simple way leave the system ready for use.

For those who don't know how to use the terminal and aren't familiar with Linux systems, it makes a total difference using just one command that do all. I added sections separated by category to make it easier for beginner users, making advanced changes to the system's kernel in an automated and safe way to make the experience easier. for beginners as pleasant and simple as possible.

I made the script as transparent as possible for anyone to understand and verify the commands executed, not needing to consult a huge amount of source code to trust or not the execution, just checking the changes that will be made, obviously there is still a lot to simplify and optimize.

Now about the script:
I tried to make the installation tasks for basic applications as simple as Windows and not too confusing as a Linux beginner might find, and as selective as possible to let the user correctly choose what type of changes they would like to use.
The focus here is not to use a modified image of the system, so that the user can have the confidence of a stable Opensuse system and Rolling Release straight from the original source without hidden modifications and without having to check everything that has been modified, he can do a simple uncomplicated check in the script code to see exactly what is being installed and choose not to make changes you don't want.
I am fully aware that this script needs to be improved, reduced and simplified, but I am new to Shell Script. Any contribution to this project will be welcome.

OpenSUSE Leap 15.6 / Tumbleweed:
The choice of OpenSUSE was based on several tests that I performed on many distributions, and Opensuse in my opinion (I know it's completely questionable) is the most stable, safe and with the best performance, both in games and in general system performance, for open applications and perform daily tasks.
In particular, I noticed that in Wine the performance is much superior to other distributions, due to Opensuse always delivering the latest updates, it makes the system fluids impeccable, With better results on Tumbleweed for being Rolling Release!
In tests that I carried out in games via Wine, they showed a much higher margin than other distros focused on games such as Nobara Project and winesapOS, I used these two distros in particular as an example because both have several modifications aimed at Games, especially via Wine, modifications that for the most part, Opensuse dispenses, with these fixes already applied in the most recent updates.
Another factor is that for me Opensuse has become an "unbreakable" system, even if it's Rolling Release in the case of Tumbleweed, because with the use of Snapper (already integrated into the system) I can revert the whatever changes to the system without difficulty, not to mention the possibility of using Timeshift for full system backups to be facilitated by using standard BTRFS partitioning.

My work here consists of small modifications to enable PCI Passthrough for those who want to use a Virtual Machine with a dedicated GPU, changes to kernel settings to enable advanced features, shortcuts for easy installation of common and advanced applications, and some minor edits to boot configurations for some applications.


What system modifications does the MaxxedSUSE Script perform?

Opensuse 15.6:

    Added repositories:

    Exclusive MaxxedSUSE repository to bring some useful tools to Leap 15.6:
    https://download.opensuse.org/repositories/home:/MaxxedSUSE:15.6/ MaxxedSUSE

    https://download.opensuse.org/repositories/Emulators:/Wine/15.5/ Wine
    https://download.opensuse.org/repositories/system:/snappy/openSUSE_Leap_15.5/ snappy
    http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_15.6/ packman

Opensuse Tumbleweed:

    Added repositories:

    Exclusive MaxxedSUSE repository to bring some useful tools to Tumbleweed:
    https://download.opensuse.org/repositories/home:/MaxxedSUSE/openSUSE_Tumbleweed

    https://download.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed snappy
    https://mirrorcache-us.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ Wine
    http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman



Some kernel parameters loaded for better Nvidia driver operation and to enable GPU PCI Passthrough.
added depending on the processor options selected during script execution:

    nvidia-drm.modeset=1
    intel_iommu=on
    amd_iommu=on
    iommu=en rd.driver.pre=vfio-pci

    For waydroid only (optional installation)
    psi=1

Snap daemon configuration to allow installation of Snaps.

    zypper --non-interactive dup --from snappy
    zypper --non-interactive install snapd
    systemctl enable --now snapd
    systemctl enable --now snapd.apparmor
    systemctl start snapd.apparmor
    systemctl start snapd

Initial flathub setup to allow flatpak installations:

    flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo


Added parameters to launch some applications:

    Balena Etcher:

     --no-sandbox

    Itch.io:

    --no-sandbox


### ****** End of system changes. ****

- All other modifications or installations are done at the user's discretion during the script.


### If you need to add an application to the repository, please open an issue, I don't promise anything, but I will do my best to add it.


Best regards, Jonatas Gonçalves

Linkedin: https://www.linkedin.com/in/jonatasgonçalves/
Twitter: https://twitter.com/jsougoncalves


GPLv3
