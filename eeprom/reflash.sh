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
    \curl -sS https://get.pimoroni.com/i2c0 | sudo bash -s - "-y"
fi

if [ -e $CONFIG ] && grep -q "^dtparam=i2c_vc=on$" $CONFIG; then
    echo "i2c0 bus is active"
else
    echo "i2c0 bus must be enabled"
    \curl -sS https://get.pimoroni.com/i2c0 | sudo bash -s - "-y"
fi

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

sudo sed -i "s|^dtparam=i2c_vc=on|#dtparam=i2c_vc=on|" $CONFIG &> /dev/null

exit 0
