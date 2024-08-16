#!/bin/bash

ESC_SEQ="\x1b["
COL_RESET=$ESC_SEQ"39;49;00m"
RED=$ESC_SEQ"31;01m"
GREEN=$ESC_SEQ"32;01m"


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
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo
    echo -e "$GREEN                                               MaxxedSUSE Install Script                                          $COL_RESET"
    echo
    echo -e "$GREEN                                            Starting Maxxeding your SUSE !!!                                       $COL_RESET"
    echo
    echo
    echo -e "$GREEN                                All changes of this script are described on github !!!                        $COL_RESET"
    echo
    echo -e "$RED                                              DON'T TRUST ME, VERIFY !!!                                      $COL_RESET"
    echo
    echo -e "$GREEN                       Check for updates at https://github.com/Jonatas-Goncalves/MaxxedSUSE                   $COL_RESET"
    echo
    echo
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo
    echo
    echo
    echo
    echo
    echo
    sleep 5
    clear

    echo
    echo Installing git to download MaxxedSUSE!!
    # Instaling git to get MaxxedSUSE
    if ! rpm -q git &>/dev/null; then
        xdg-su -c "zypper --non-interactive install git" 2>/dev/null
	fi
    echo
    echo

    echo Checking for updates in MaxxedSUSE Script...
    # Check if MaxxedSUSE directory exists
    if [ -d "$HOME/MaxxedSUSE" ]; then
    echo "MaxxedSUSE directory found. Checking for updates..."

    # Change directory to MaxxedSUSE
    cd "$HOME/MaxxedSUSE"

    # Fetch updates from the remote repository
    git fetch origin

    # Check if there are changes in the remote branch
    if git rev-parse --quiet --verify Staging@{upstream} >/dev/null; then
        # There are changes, pull the latest changes
        echo "Updating MaxxedSUSE repository..."
        git pull origin Staging
    else
        # No changes, repository is up to date
        echo "MaxxedSUSE repository is already up to date."
    fi
    else
    # The directory does not exist, so we clone the repository
    echo "MaxxedSUSE directory not found. Cloning repository..."
    git clone --single-branch --branch main https://github.com/Jonatas-Goncalves/MaxxedSUSE "$HOME/MaxxedSUSE"
    fi
    cd /home/$USER/MaxxedSUSE
    clear

    echo
    echo
    echo Need root password once again to start MaxxedSUSE !!
    echo
    echo
    # Starting MaxxedSUSE
    xdg-su -c "sudo -sE bash Start.sh" 2>/dev/null
