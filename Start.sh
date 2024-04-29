#!/bin/bash

source ./Scripts/Functions/Find.sh
FIND /Scripts/Functions/ Functions.sh

if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo";
    exit 0
else
    crontab -l | grep -v "@reboot ~/MaxxedSUSE/Start.sh" | crontab -
    # Check if zenity is installed, if not, install it
    CHECK_DEPENDS_ELSE_INSTALL

    if [ -f .start.txt ]; then
        if grep -q "DONE" ".start.txt"; then
            echo "Repos already configured."
        else
            rm .start.txt
            echo "DONE" > .start.txt
        fi
    else
        echo "DONE" > .start.txt
    # Displays the dialog box
    zenity --question --text="On first use MaxxedSUSE will:

Add the following repositories:
- MaxxedSUSE
- Flatpak
- Packman
- Snap
- Wine

Will install the necessary dependencies to configure them.
We will then update the system.

This process should not be interrupted and will restart inadvertently, would you like to start now?" --title="MaxxedSUSE Setup" 2>/dev/null

    # Gets the user's response
    response=$?

    # Check the answer
    if [ $response -eq 0 ]; then
        # If the user selects "Yes", run the RUN_UPDATE_ONCE command
        RUN_UPDATE_ONCE
        CONFIGURE_SNAP_FLATPAK_ONCE
        CONFIGURE_CODECS_ONCE
    else
        echo "Update process cancelled by the user."
        exit 0
    fi
	fi
fi

# Run only if a superuser
if [[ $EUID -ne 0 ]]; then
	IF_NOT_SUPERUSER $(basename "$0")
   	exit 1
else
	#Zenity Checklist for all the scripts
	SEL=$( zenity --list --checklist \
		2>/dev/null --height=550 --width=720\
		--title "Do you want to Maxxedize your system or install Applications?"\
		--text="<b>START MAXXEDING YOUR OPENSUSE!\n</b>"\
		--ok-label "Start" --cancel-label "Exit"\
		--column "Pick" --column "Operation" 	--column "Description"\
		FALSE		'MAXXEDIZE YOUR SYSTEM'		"** FIRST RUN THIS ONCE **"\
		FALSE		'AUDIO AND VIDEO'		"Audio and video software"\
		FALSE 		'COMMUNICATION & BROWSERS'			"Navigation and communication"\
		FALSE 		'WORK AND SCHOOL'			"Tools for working or studying"\
		FALSE 		'DEVELOPMENT'			"Tools for programming and development"\
		FALSE 		'UTILITIES' 		"Utilities and tools for the system"\
		FALSE		'GAMES AND TOOLS'			"Tools to make gaming easier"\
		FALSE		'GAMES STORES'			"Stores to install your games"\
		FALSE		'EMULATORS'			"Most popular emulators"\
		FALSE		'ADVANCED SYSTEM TOOLS'			"System tools for advanced users" );

	# pressed Cancel or closed the dialog window
	if [[ $? -eq 1 ]]; then
  		zenity --warning --title="Cancelled" \
		--text "\nOperation cancelled by user. Nothing will be done!"\
		2>/dev/null --no-wrap
	elif [[ -z "$SEL"  ]]; then
		zenity --warning \
		--text "\nNo Option Selected. Nothing will be done!"\
		2>/dev/null --no-wrap
	else
		#this is mandatory for the space in checklist to work eg. "ADDITIONAL TWEAKS"
		IFS=$'\n'

		for option in $(echo $SEL | tr "|" "\n"); do

			case $option in

			"MAXXEDIZE YOUR SYSTEM")	#Maxxed Advanced System Settings
					FIND /Scripts/ MXD.sh
				;;

			"AUDIO & VIDEO")	#Audio and video softwares
					FIND /Scripts/ ANV.sh
				;;

			"COMMUNICATION & BROWSERS")		#Navigation and communication
					FIND /Scripts/ CNB.sh
				;;

			"WORK AND SCHOOL")		#Tools for working or studying
					FIND /Scripts/ WNS.sh
				;;

			"DEVELOPMENT")		#Tools for programming and development
					FIND /Scripts/ DEV.sh
				;;

			"UTILITIES")	#Utility applications for the system
					FIND /Scripts/ UTIL.sh
				;;

			"GAMES AND TOOLS")	#Tools to make gaming easier
					FIND /Scripts/ GNT.sh
				;;

			"GAMES STORES")	#Stores to install your games
					FIND /Scripts/ GST.sh
				;;

			"EMULATORS")	#Most popular emulators
					FIND /Scripts/ EML.sh
				;;

			"ADVANCED SYSTEM TOOLS")	#System tools for advanced users
					FIND /Scripts/ AST.sh
				;;
			esac
		done

	fi
	unset IFS

	if [[ ! -z $SEL ]]; then
		COMPLETION_NOTIFICATION 'Complete' 'Enjoy your system!'
	fi
fi
