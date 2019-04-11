#!/bin/bash

OVERLAY_PATH="/boot/overlays"
OVERLAY_NAME="picade.dtbo"

CONFIG="/boot/config.txt"
CONFIG_BACKUP="$CONFIG.picade-preuninstall"

CONFIG_LINES=(
	"dtoverlay=picade"
	"dtparam=audio=off"
)

printf "Picade HAT: Uninstaller\n\n"

if [ $(id -u) -ne 0 ]; then
	printf "Script must be run as root. Try 'sudo ./install.sh'\n"
	exit 1
fi

if [ ! -f "$CONFIG_BACKUP" ]; then
	cp $CONFIG $CONFIG_BACKUP
	printf "Notice: copying $CONFIG to $CONFIG_BACKUP\n"
fi

if [ -f "$OVERLAY_PATH/$OVERLAY_NAME" ]; then
	rm -f $OVERLAY_PATH/$OVERLAY_NAME
	printf "Removing: $OVERLAY_PATH/$OVERLAY_NAME\n"
fi

if [ -f "/$UDEV_RULES_FILE" ]; then
	rm -f /$UDEV_RULES_FILE
	printf "Removing: /$UDEV_RULES_FILE\n"
fi

if [ -f "/$ASOUND_CONF_FILE" ]; then
	rm -f /$ASOUND_CONF_FILE
	printf "Removing: /$ASOUND_CONF_FILE!\n"
fi

if [ -f "$CONFIG" ]; then
	for ((i = 0; i < ${#CONFIG_LINES[@]}; i++)); do
		CONFIG_LINE="${CONFIG_LINES[$i]}"
		grep -e "^$CONFIG_LINE" $CONFIG > /dev/null
		STATUS=$?
		if [ $STATUS -eq 0 ]; then
			sed -i "/^$CONFIG_LINE/d" $CONFIG
			printf "Config: removed \"$CONFIG_LINE\", from $CONFIG\n"
		else
			printf "Config: skipped \"$CONFIG_LINE\", not found in $CONFIG\n"
		fi
	done
else
	printf "Warning: unable to find $CONFIG, is /boot mounted?\n"
fi

printf "Uninstallation finished. You must reboot for changes to take effect!\n"
