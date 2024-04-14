#!/bin/bash

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

    echo
    echo
    echo
    echo
    echo
    echo
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN**************************************************************************************************************$COL_RESET"
    echo -e "$GREEN                                                                                                              $COL_RESET"
    echo -e "$GREEN                                           MaxxedSUSE Install Script                                          $COL_RESET"
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
    echo
    echo
    echo
    echo
    #sleep 5
    clear

    # Instaling git to get MaxxedSUSE
    echo Root password is necessary to install Git
    sudo zypper --non-interactive in git

    # Clone the repository to MaxxedSUSE folder in the home directory
    echo
    echo
    echo Cloting MaxxedSUSE Script
    echo
    echo
    git clone --single-branch --branch Staging https://github.com/Jonatas-Goncalves/MaxxedSUSE ~/MaxxedSUSE
    cd /home/$USER/MaxxedSUSE

    # Starting MaxxedSUSE
    echo
    echo
    echo Enter the root password once again to run MaxxedSUSE
    echo
    echo
    xdg-su -c "sudo -sE bash Start.sh"
