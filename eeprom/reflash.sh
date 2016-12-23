#!/bin/bash

flashblob="yes"
forceflash="yes"

script="eeprom.py"
productid="Picade HAT"
settings="picade-hat.settings"
hatdtbo="picade-hat.dtbo"

success() {
    echo -e "$(tput setaf 2)$1$(tput sgr0)"
}

warning() {
    echo -e "$(tput setaf 1)$1$(tput sgr0)"
}

echo ""

if [ "$flashblob" == "yes" ] && [ "$forceflash" == "yes" ]; then
	sudo python $script write "$settings" "$hatdtbo" force
elif [ "$flashblob" == "yes" ]; then
	sudo python $script write "$settings" "$hatdtbo"
elif [ "$forceflash" == "yes" ]; then
	sudo python $script write "$settings" force
else
	sudo python $script write "$settings"
fi

match=$(sudo python $script write "$settings" | grep "$productid")

if [ -n "$match" ]; then
    success "\nproduct ID match settings\n"
else
    warning "\nproduct ID does NOT match!!!!!!!!!!!!!\n"
fi

exit 0
