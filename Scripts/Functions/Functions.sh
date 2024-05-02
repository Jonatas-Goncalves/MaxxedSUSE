#!/bin/bash

export PATH=/bin:/usr/bin:/usr/local/bin:/sbin:/usr/sbin:/usr/local/sbin

GET_SYSTEM_ARCH() {
	Arch=$(arch)
	echo "$Arch"
}

RUN_UPDATE_ONCE() {
    if [ -f .update.txt ]; then
        if grep -q "DONE" ".update.txt"; then
            echo "Repos already configured."
        else
            rm .update.txt
            echo "DONE" > .update.txt
        fi
    else
        echo "DONE" > .update.txt

        # Detect openSUSE version
        OPEN_SUSE_VERSION=$(cat /etc/os-release | grep '^ID=' | cut -d '=' -f 2 | tr -d '"')

        # Add repositories based on openSUSE version
        if [ "$OPEN_SUSE_VERSION" = "opensuse-leap" ]; then
        # Show progress dialog
        (
        echo "10" # Initial progress value
        sleep 3 # Simulate an operation delay
        echo "# Adding MaxxedSUSE, Flatpak, Packman, Snap, and Wine repositories"
        echo "30" # Progress after adding repositories
        sleep 3 # Simulate an operation delay
            # Add repositories for openSUSE Leap 15.6
            sudo sh -c 'echo -e "[MaxxedSUSE]\nname=MaxxedSUSE\nbaseurl=https://download.opensuse.org/repositories/home:MaxxedSUSE:15.6/15.6/\nenabled=1\ngpgcheck=0\nautorefresh=1\nrepo_gpgcheck=1\ngpgkey=https://download.opensuse.org/repositories/home:MaxxedSUSE:15.6/15.6/repodata/repomd.xml.key" > /etc/zypp/repos.d/MaxxedSUSE.repo'
            sudo sh -c 'echo -e "[MaxxedSUSE-Emulators]\nname=MaxxedSUSE-Emulators\nbaseurl=https://download.opensuse.org/repositories/home:MaxxedSUSE:Emulators/15.6/\nenabled=1\ngpgcheck=0\nautorefresh=1\nrepo_gpgcheck=1\ngpgkey=https://download.opensuse.org/repositories/home:MaxxedSUSE:Emulators/repodata/repomd.xml.key" > /etc/zypp/repos.d/MaxxedSUSE-Emulators.repo'
            sudo zypper --gpg-auto-import-keys addrepo https:/| grep '^VERSION_ID='/download.opensuse.org/repositories/Emulators:/Wine/15.5/ Wine
            sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/system:/snappy/openSUSE_Leap_15.5 snappy
            sudo zypper --gpg-auto-import-keys addrepo -cfp 90 http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Leap_15.6/ packman
        echo "# Installing necessary dependencies"
        echo "60" # Progress after installing dependencies
        sleep 3 # Simulate an operation delay
        sudo zypper --gpg-auto-import-keys refresh
        echo "# Updating the system"
        echo "100" # Progress upon finishing the update
        sleep 3 # Wait for 2 seconds before closing the progress dialog
        sudo zypper --non-interactive dup --auto-agree-with-licenses --no-confirm --no-recommends
        ) | zenity --progress --title="Updating System" --text="Please wait..." --auto-close

        elif [ "$OPEN_SUSE_VERSION" = "opensuse-tumbleweed" ]; then
        # Show progress dialog
        (
        echo "10" # Initial progress value
        sleep 3 # Simulate an operation delay
        echo "# Adding MaxxedSUSE, Flatpak, Packman, Snap, and Wine repositories"
        echo "30" # Progress after adding repositories
        sleep 3 # Simulate an operation delay
            # Add repositories for openSUSE Tumbleweed
            sudo sh -c 'echo -e "[MaxxedSUSE]\nname=MaxxedSUSE\nbaseurl=https://download.opensuse.org/repositories/home:MaxxedSUSE/openSUSE_Tumbleweed/\nenabled=1\ngpgcheck=0\nautorefresh=1\nrepo_gpgcheck=1\ngpgkey=https://download.opensuse.org/repositories/home:MaxxedSUSE/openSUSE_Tumbleweed/repodata/repomd.xml.key" > /etc/zypp/repos.d/MaxxedSUSE.repo'
            sudo sh -c 'echo -e "[MaxxedSUSE-Emulators]\nname=MaxxedSUSE-Emulators\nbaseurl=https://download.opensuse.org/repositories/home:MaxxedSUSE:Emulators/openSUSE_Tumbleweed/\nenabled=1\ngpgcheck=0\nautorefresh=1\nrepo_gpgcheck=1\ngpgkey=https://download.opensuse.org/repositories/home:MaxxedSUSE:Emulators/repodata/repomd.xml.key" > /etc/zypp/repos.d/MaxxedSUSE-Emulators.repo'
            sudo zypper --gpg-auto-import-keys addrepo https://download.opensuse.org/repositories/Emulators:/Wine/openSUSE_Tumbleweed/ Wine
            sudo zypper --gpg-auto-import-keys addrepo https://mirrorcache-us.opensuse.org/repositories/system:/snappy/openSUSE_Tumbleweed/ snappy
            sudo zypper --gpg-auto-import-keys addrepo -cfp 90 http://ftp.gwdg.de/pub/linux/misc/packman/suse/openSUSE_Tumbleweed/ packman
        echo "# Installing necessary dependencies"
        echo "60" # Progress after installing dependencies
        sleep 3 # Simulate an operation delay
        sudo zypper --gpg-auto-import-keys refresh
        echo "# Updating the system"
        echo "100" # Progress upon finishing the update
        sleep 3 # Wait for 2 seconds before closing the progress dialog
        sudo zypper --non-interactive dup --auto-agree-with-licenses --no-confirm --no-recommends
        ) | zenity --progress --title="Updating System" --text="Please wait..." --auto-close

        fi

        (crontab -l ; echo "@reboot ~/MaxxedSUSE/Start.sh") | crontab -

        sudo reboot

    fi
}

CONFIGURE_SNAP_FLATPAK_ONCE() {
    if [ -f .snapflat.txt ]; then
        if grep -q "DONE" ".snapflat.txt"; then
            echo "Repos already configured."
        else
            rm .snapflat.txt
            echo "DONE" > .snapflat.txt
        fi
    else
        echo "DONE" > .snapflat.txt
            echo -e "$YELLOW    Configuring Snap Services !!!    $COL_RESET"
            sudo zypper --non-interactive dup --from snappy
            sudo zypper --non-interactive install snapd
            USER=$(cat /etc/passwd|grep 1000|sed "s/:.*$//g");
	        su $USER -c "source /etc/profile && source ~/.bashrc"
            sleep 2
            sudo systemctl enable --now snapd
            sudo systemctl enable --now snapd.apparmor
            sudo systemctl start snapd.apparmor
            sudo systemctl start snapd

            echo -e "$YELLOW    Configuring Flatpak Services !!!    $COL_RESET"
            sudo zypper --non-interactive install dbus-1
            flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
            USER=$(cat /etc/passwd|grep 1000|sed "s/:.*$//g");
	        su $USER -c "source /etc/profile && source ~/.bashrc"
			su $USER -c "export XDG_DATA_DIRS="/var/lib/flatpak/exports/share:$XDG_DATA_DIRS""
	fi
}

CONFIGURE_CODECS_ONCE() {
    if [ -f .codecs.txt ]; then
        if grep -q "DONE" ".codecs.txt"; then
            echo "Repos already configured."
        else
            rm .codecs.txt
            echo "DONE" > .codecs.txt
        fi
    else
        echo "DONE" > .codecs.txt
            echo -e "$YELLOW    Installing media codecs !!!    $COL_RESET"
            sudo zypper --non-interactive install --allow-vendor-change --from packman \
            ffmpeg gstreamer-plugins-bad lame gstreamer-plugins-libav gstreamer-plugins-ugly\
            gstreamer-plugins-ugly-orig-addon libavresample4 libavdevice57 vlc-codecs
	fi
}

CHECK_DEPENDS_ELSE_INSTALL() {
	# Check if zenity and dpkg is installed, if not, install it
	if ! rpm -q zenity &>/dev/null; then
		sudo zypper --non-interactive install zenity
	fi
	if ! rpm -q dpkg &>/dev/null; then
		sudo zypper --non-interactive install dpkg
	fi
	if ! rpm -q curl &>/dev/null; then
		sudo zypper --non-interactive install curl
	fi
}


IF_NOT_SUPERUSER() {
	ScriptName=$1
	#every zenity command will have height=480 and width=720 for the sake of uniformity
	zenity --error --icon-name=error --title="ROOT permission required!" --text="\nThis script requires ROOT permission. Run with sudo!" --no-wrap 2>/dev/null
	notify-send -u normal "ERROR" "Re-run $1"
}

COMPLETION_NOTIFICATION() {
	Title=$1
	Text=$2
	
	#notify-send cannot work as root
	USER=$(cat /etc/passwd|grep 1000|sed "s/:.*$//g");
	su $USER -c "/usr/bin/notify-send -u normal '$Title' '$Text'"
}


