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

if ls /dev/i2c* &> /dev/null; then
    echo "I2C already enabled"
else
    echo "I2C must be enabled"
    \curl -sS https://get.pimoroni.com/i2c | sudo bash -s - "-y"
fi

sudo dtparam i2c_vc=on

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
