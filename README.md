# Picade HAT (Device-tree Overlay)

This repository contains the software you need to get started with your Picade HAT.

Before you continue, you should make sure that you're running the latest RetroPie, have your Pi connected to the internet and have a keyboard ready to run through the setup steps.

If you want to use the old Python driver for Picade HAT, see `legacy-python-driver`.

# Preparing RetroPie

Create yourself a new RetroPie SD card with the image found here: https://retropie.org.uk/download/

If you're using a Pi 3, or a Pi with a wireless adaptor, you can also drop a `wpa_supplicant.conf` into the BOOT folder.

On first boot, at the control config screen hit F4 to exit to the command-line.

## WiFi

If you dropped a `wpa_supplicant.conf` into `/boot`, it wont be installed by default, yet, but now it's easy to set up your WiFi like so:

```
sudo cp /boot/wpa_supplicant.conf /etc/wpa_supplicant/
sudo ifdown wlan0
sudo ifup wlan0
``` 

# One-line Installation (Recommended)

Before setting up your RetroPie config, just hit F4 and then type:

```
curl -sS https://get.pimoroni.com/picadehat | bash
```

Setup will continue automatically. 

When it's finished, you must reboot.

Finally, bind your input as normal!

# Automatic Installation

* Clone this GitHub repository somewhere onto your Pi: `git clone https://github.com/pimoroni/picade-hat`

* Enter the new directory: `cd picade-hat`

* Run the installer: `sudo ./install.sh`

* Reboot `sudo reboot`

* Bind your controls and enjoy!

# Software Details

This overlay supplies all of the functionality for Picade HAT using built-in drivers on the Raspberry Pi.

It will:

* Bind the 14 buttons to linux keycodes from a virtual keyboard input
* Optionally: bind the power button to KEY_POWER to trigger a shutdown
* Optionally: assert BCM4 upon shutdown, to cut the power from the HAT to the Pi
* Optionally: set up i2s audio to work with Picade HAT
* Optionally: re-route the Pi's act LED and give you control over the trigger function

See picade.txt for full documentation.

## Manually Building & Installing

You can run `make` and `sudo make install` to install `picade.dtbo` in your `/boot/overlays/` folder.

Once done, edit `/boot/config.txt` and add `dtoverlay=picade` to the bottom.

See picade.txt for the various options you can supply to this command.

