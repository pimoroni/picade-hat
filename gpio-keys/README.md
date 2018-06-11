# Picade HAT Device-tree Overlay

This overlay supplies all of the functionality for Picade HAT using built-in drivers on the Raspberry Pi.

It will:

* Bind the 14 buttons to linux keycodes from a virtual keyboard input
* Optionally: bind the power button to KEY_POWER to trigger a shutdown
* Optionally: assert BCM4 upon shutdown, to cut the power from the HAT to the Pi
* Optionally: set up i2s audio to work with Picade HAT
* Optionally: re-route the Pi's act LED and give you control over the trigger function

See picade.txt for full documentation.

## Building & Installing

You can run `make` and `sudo make install` to install `picade.dtbo` in your `/boot/overlays/` folder.

Once done, edit `/boot/config.txt` and add `dtoverlay=picade` to the bottom.

See picade.txt for the various options you can supply to this command.
