# Picade HAT X Support for Lakka

These experimental instructions aim to get Picade HAT X up and running on Lakka using the `gpio-key` kernel module. In this mode, Picade HAT X emulates a keyboard and the keys should correspond with Lakka's expected defaults.

A, B, X, and Y are the left-most of the 6 face buttons in a Picade or Picade Console build. The two remaining buttons have been assigned to keys "q" and "w" which you can optionally bind as "L2" and "R2".

The expansion headers for Button 7 and 8 have been assigned as "Vol Up" and "Vol Down"

## Installation

Copy `picade.dts` and `10-picade.rules` onto your Lakka system. You can either put your Lakka SD card into your PC and copy this file over once booted, or `scp` them onto a running system. In either case you will first need to enable SSH which you can do under Settings -> Services. The default SSH login and password for Lakka are `root` and `root` respectively.

Once you're SSH'ed in you will need to gain write access to the "flash" boot/LAKKA partition on the SD card:

```
mount -o,remount,rw /flash
```

With write access enabled, you can now copy `10-picade.rules` into `.config/udev.rules.d/`:

```
cp 10-picade.rules /storage/.config/udev.rules.d/
```

And build the device-tree overlay file you will need:

```
cp picade.dts /flash/picade.dts
dtc -I dts -O dtb -o /flash/overlays/picade.dtbo /flash/picade.dts
```

If desired you can edit `picade.dts` and change the Linux keycodes, for a list of which keycode corresponds to which key see: https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h

Finally edit `config.txt` and add `dtoverlay=picade` to the end.

```
nano /flash/config.txt
```

Use `CTRL+X` to exit and make sure to save your changes.

Set `/flash` mountpoint back to read only mode:
```
mount -o remount,ro /flash
```

Reboot to enable Picade HAT X compatibility, at this point Picade HAT X should just emulate a regular keyboard.

To enable audio pick "default:CARD=sndrpihifiberry" in the Settings->Audio->Device menu. You can cycle through audio devices by hitting left/right.
