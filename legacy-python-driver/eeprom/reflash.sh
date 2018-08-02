#!/bin/bash

flashblob="yes"
forceflash="yes"

script="eeprom.py"
productid="Picade HAT"
settings="picade-hat.settings"
hatdtbo="picade-hat.dtbo"

CONFIG=/boot/config.txt
DTBODIR=/boot/overlays

success() {
    echo -e "$(tput setaf 2)$1$(tput sgr0)"
}

warning() {
    echo -e "$(tput setaf 1)$1$(tput sgr0)"
}

newline() {
    echo ""
}

newline

if [ "$flashblob" == "yes" ] && [ "$forceflash" == "yes" ]; then
	sudo python $script write "$settings" "$hatdtbo" force
elif [ "$flashblob" == "yes" ]; then
	sudo python $script write "$settings" "$hatdtbo"
elif [ "$forceflash" == "yes" ]; then
	sudo python $script write "$settings" force
else
	sudo python $script write "$settings"
fi

product=$(sudo python $script read product)

if [ -n "$product" ]; then
    success "\nproduct ID match settings\n"
else
    warning "\nproduct ID does NOT match!!!!!!!!!!!!!\n"
fi

exit 0
