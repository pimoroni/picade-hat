#!/bin/bash

OVERLAY_PATH="/boot/overlays"
OVERLAY_NAME="picade.dtbo"

CONFIG="/boot/config.txt"
CONFIG_BACKUP="$CONFIG.picade-preinstall"

UDEV_RULES_FILE="etc/udev/rules.d/10-picade.rules"
ASOUND_CONF_FILE="etc/asound.conf"

CONFIG_LINES=(
	"dtoverlay=picade"
	"dtparam=audio=off"
	"hdmi_force_hotplug=1"
)

printf "Picade HAT: Installer\n\n"

if [ $(id -u) -ne 0 ]; then
	printf "Script must be run as root. Try 'sudo ./install.sh'\n"
	exit 1
fi

if [ ! -f "$OVERLAY_NAME" ]; then
	if [ ! -f "/usr/bin/dtc" ]; then
		printf "This script requires device-tree-compiler, please \"sudo apt install device-tree-compiler\"\n";
		exit 1
	fi
	printf "Notice: building picade.dtbo\n";
	make > /dev/null 2>&1
fi

if [ ! -f "$CONFIG_BACKUP" ]; then
	cp $CONFIG $CONFIG_BACKUP
	printf "Notice: copying $CONFIG to $CONFIG_BACKUP\n"
fi

if [ -d "$OVERLAY_PATH" ]; then
	cp $OVERLAY_NAME $OVERLAY_PATH/$OVERLAY_NAME
	printf "Installed: $OVERLAY_PATH/$OVERLAY_NAME\n"
else
	printf "Warning: unable to copy $OVERLAY_NAME to $OVERLAY_PATH\n"
fi

if [ ! -f "/$UDEV_RULES_FILE" ]; then
	cp $UDEV_RULES_FILE /$UDEV_RULES_FILE
	printf "Installed /$UDEV_RULES_FILE\n"
else
	printf "Warning: /$UDEV_RULES_FILE already exists, not replacing!\n"
fi

if [ ! -f "/$ASOUND_CONF_FILE" ]; then
	cp $ASOUND_CONF_FILE /$ASOUND_CONF_FILE
	printf "Installed /$ASOUND_CONF_FILE\n"
else
	printf "Warning: /$ASOUND_CONF_FILE already exists, not replacing!\n"
fi

if [ -f "$CONFIG" ]; then
	NEWLINE=0
	for ((i = 0; i < ${#CONFIG_LINES[@]}; i++)); do
		CONFIG_LINE="${CONFIG_LINES[$i]}"
		grep -e "^#$CONFIG_LINE" $CONFIG > /dev/null
		STATUS=$?
		if [ $STATUS -eq 1 ]; then
			grep -e "^$CONFIG_LINE" $CONFIG > /dev/null
			STATUS=$?
			if [ $STATUS -eq 1 ]; then
				# Line is missing from config file
				if [ ! $NEWLINE -eq 1 ]; then
					# Add newline if this is the first new entry
					echo "" >> $CONFIG
					NEWLINE=1
				fi
				# Add the config line
				echo "$CONFIG_LINE" >> $CONFIG
				printf "Config: Added \"$CONFIG_LINE\" to $CONFIG\n"
			else
				printf "Config: Skipped \"$CONFIG_LINE\", already exists in $CONFIG\n"
			fi
		else
			sed $CONFIG -i -e "s/^#$CONFIG_LINE/$CONFIG_LINE/"
			printf "Config: Uncommented \"$CONFIG_LINE\" in $CONFIG\n"
		fi
	done
else
	printf "Warning: unable to find $CONFIG, is /boot mounted?\n"
fi

printf "Installation finished. You must reboot for changes to take effect!\n"
