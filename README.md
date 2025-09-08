# Picade HAT (Device-tree Overlay)

This repository contains the software you need to get started with your Picade HAT.

Before you run our installer, you should make sure that you're running the latest RetroPie, have your Pi connected to the internet and have a keyboard ready to run through the setup steps.

If you want to use the old Python driver for Picade HAT, see `legacy-python-driver`.

# Preparing RetroPie

If you're using a Pi 4 or earlier, you can create yourself a new RetroPie SD card with the image found here: https://retropie.org.uk/download/ (it's also available through Raspberry Pi Imager).

If you're using a Pi 5 you'll need to flash Raspberry Pi OS to your SD card and then run [RetroPie's installer script](https://github.com/RetroPie/RetroPie-Setup).

Step by step instructions can be found in our Learn guide:

- [Setting Up Picade](https://learn.pimoroni.com/article/setting-up-picade)

On first boot, at the control config screen hit F4 to exit to the command-line.

# Setting Up Wi-Fi

If you have a keyboard connected to your Picade, you can set-up wi-fi using the Raspberry Pi Configuration utility. Run:

`sudo raspi-config`

The options to configure wi-fi are under 'System Options' > 'Wireless LAN'.

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

Once installed, you can change the line in `/boot/firmware/config.txt` (or `boot/config.txt` in older OSes) to customise your Picade HAT install:

Bind up/down/left/right to wasd and disable digital audio:

```
dtoverlay=picade,up=17,down=31,left=30,right=32,noaudio
```

Only use the default keyboard bindings, no other features:

```
dtoverlay=picade,noaudio,noactled,nopowerbtn,nopoweroff
```

Set the act LED to show cpu0 activity:

```
dtoverlay=picade,led-trigger=cpu0
```

**Note:** There's an 80 character line-length limit for `dtoverlay`.

If you want to change many parameters you should use the `dtparam` command like so:

```
dtoverlay=picade
dtparam=up=17
dtparam=down=31
dtparam=left=30
dtparam=right=32
# etc
```

See picade.txt for full documentation.

## Manually Building & Installing

You can run `make` and `sudo make install` to install `picade.dtbo` in your `/boot/overlays/` folder.

Once done, edit `/boot/firmware/config.txt` and add `dtoverlay=picade` to the bottom.

See picade.txt for the various options you can supply to this command.

