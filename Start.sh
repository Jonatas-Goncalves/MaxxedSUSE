#!/bin/bash

source ./Scripts/Functions/Find.sh
FIND /Scripts/Functions/ Functions.sh

if [[ $EUID -ne 0 ]]; then
    echo "Run with sudo";
    exit 0
else
    # Verifica se o zenity está instalado, caso contrário, instala
    CHECK_DEPENDS_ELSE_INSTALL

    # Exibe a caixa de diálogo
    zenity --question --text="On first use MaxxedSUSE will:

Add the following repositories:
- MaxxedSUSE
- Flatpak
- Packman
- Snap
- Wine

Will install the necessary dependencies to configure them.
We will then update the system.

This process should not be interrupted, would you like to start now?" --title="MaxxedSUSE Setup" 2>/dev/null

    # Obtém a resposta do usuário
    response=$?

    # Verifica a resposta
    if [ $response -eq 0 ]; then
        # Se o usuário selecionar "Sim", execute o comando RUN_UPDATE_ONCE
        RUN_UPDATE_ONCE
        CONFIGURE_SNAP_FLATPAK_ONCE
        CONFIGURE_CODECS_ONCE
    else
        echo "Update process cancelled by the user."
        exit 0
    fi
fi

# run only if a superuser
if [[ $EUID -ne 0 ]]; then
	IF_NOT_SUPERUSER $(basename "$0")
   	exit 1
else
	#Zenity Checklist for all the scripts
	SEL=$( zenity --list --checklist \
		2>/dev/null --height=450 --width=720\
		--title "Do you want to Maxxedize your system or install Applications?"\
		--text="<b>START MAXXEDING YOUR OPENSUSE!\n</b>"\
		--ok-label "Start" --cancel-label "Exit"\
		--column "Pick" --column "Operation" 	--column "Description"\
		FALSE		'MAXXEDIZE YOUR SYSTEM'		"Maxxed Advanced System Settings"\
		FALSE		'AUDIO & VIDEO'		"Audio and video software"\
		FALSE 		'COMMUNICATION & BROWSERS'			"Navigation and communication"\
		FALSE 		'UTILITIES' 		"Utility applications for the system"\
		FALSE		'GAMES AND TOOLS'			"Tools to make gaming easier"\
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
					FIND /Scripts/ AAV.sh
				;;

			"COMMUNICATION & BROWSERS")		#Navigation and communication
					FIND /Scripts/ CNB.sh
				;;

			"UTILITIES")	#Utility applications for the system
					FIND /Scripts/ UTIL.sh
				;;

			"GAMES AND TOOLS")	#Tools to make gaming easier
					FIND /Scripts/ GNT.sh
				;;

			"GAMES STORES")	#Tools to make gaming easier
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
