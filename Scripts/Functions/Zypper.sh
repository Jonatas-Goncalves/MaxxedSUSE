#!/bin/bash


ZYPPER_INSTALL() {
	Software=$1
	Name=$2
	Zypperlisting=$3
	
	#if already present, don't install
	if [[ $(which $Zypperlisting | grep -w "$Zypperlisting" | awk {'print $0'}) ]]; then
		zenity --info --timeout 5 \
		--text="\n$Name Already Installed\t\t"\
		--title "Installed" --no-wrap 2>/dev/null
	else
		#Installing
		(sudo zypper --non-interactive --no-gpg-checks --gpg-auto-import-keys install --allow-unsigned-rpm --auto-agree-with-licenses $Software 2>/dev/null | \
		tee >(xargs -I % echo "#%")) | \
		zenity --progress --width=720 --pulsate --title="$Name" \
		--no-cancel --auto-kill --auto-close 2>/dev/null
		
		#Installation Complete Dialog
		INSTALLATION_COMPLETE $Name $Zypperlisting
	fi
}


ZYPPER_REFRESH() {
	(sudo zypper --gpg-auto-import-keys refresh 2>/dev/null | \
	tee >(xargs -I % echo "#%")) | \
	zenity --progress --width=720 --pulsate --title="Refreshing Zypper repos" \
	--no-cancel --auto-kill --auto-close 2>/dev/null
}


#--How to USE--#
# INSTALLATION_COMPLETE $VAR_NAME
#--------------#
INSTALLATION_COMPLETE() {
	Name=$1
	Zypperlisting=$2

	zenity --info --timeout 2 \
	--text="\nInstallation Complete\t\t"\
	--title "$Name" --no-wrap 2>/dev/null
}
