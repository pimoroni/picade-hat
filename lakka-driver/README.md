# Picade HAT X Support for Lakka v5.0

These experimental instructions aim to get Picade HAT X up and running on Lakka using the `gpio-key` kernel module.
In this mode, Picade HAT X emulates some keyboard keycode or gamepad keycode.
```
                                                                 
                        Lakka -  Picade                          
                                                                 
    +------------------------------------------------------+     
    |                                                      |     
    |                                          +---+       |     
 L2 |        Up                         +---+  |L1 |       | R2  
  +-+         ^                  +---+  | Y |  +---+       +-+   
  | |         |   Right          | X |  +---+              | |   
  +-+      <--o-->               +---+         +---+       +-+   
    |   Left  |                         +---+  |R1 |       |     
    |         v                  +---+  | A |  +---+       |     
    |         Down               | B |  +---+              |     
    |                            +---+                     |     
    |                                                      |     
    +---+---+--------------------------------------+---+---+     
        +---+                                      +---+         
        Select                                     Start         
                                                                 
```

Up=KEY_UP(103), Down=KEY_DOWN(108), Left=KEY_LEFT(105), Right=KEY_RIGHT(106)
X=BTN_X(0x133), Y=BTN_Y(0x134), L1=BTN_TL(0x136)
A=BTN_A(0x130), B=BTN_B(0x131), R1=BTN_TR(0x137)
L2=BTN_TL2(0x138), R2=BTN_TR2(0x139)
Select=BTN_SELECT(0x13b), Start=BTN_START(0x13a)

The expansion headers for Button 7 and 8 have been assigned as "+"(Vol Up) and "-"(Vol Down)

Between Paicade and Paicade Console, Coin button and 1UP button layout is swapped.
This difference is fixed via distroconfig.txt.


## Installation

Copy `10-picade.rules`, `asound.conf`, `gpio_keys.cfg` and `picade.dts` onto your Lakka system.
You can either put your Lakka SD card into your PC and copy this file over once booted, or `scp` them onto a running system.
In either case you will first need to enable SSH which you can do under Settings -> Services.
The default SSH login and password for Lakka are `root` and `root` respectively.

Once you're SSH'ed in you will need to gain write access to the "flash" boot/LAKKA partition on the SD card:

```
mount -o remount,rw /flash
```

With write access enabled, you can now copy `10-picade.rules` into `.config/udev.rules.d/`:

```
cp 10-picade.rules /storage/.config/udev.rules.d/
```

Next, you copy `asound.conf` into `/storage/.config/`:

```
cp asound.conf /storage/.config/
```

Next, you copy `gpio_keys.cfg` into `/storage/joypads/`:

```
mkdir -p /storage/joypads/udev/
cp gpio_keys.cfg /storage/joypads/udev/
```

And build the device-tree overlay file you will need:

```
cp picade.dts /flash/picade.dts
dtc -I dts -O dtb -o /flash/overlays/picade.dtbo /flash/picade.dts
```

If desired you can edit `picade.dts` and change the Linux keycodes, for a list of which keycode corresponds to which key see: https://github.com/torvalds/linux/blob/master/include/uapi/linux/input-event-codes.h

Finally edit `distroconfig.txt` and add Picade:`dtoverlay=picade` or Picade Console:`dtoverlay=picade,coin=0x13a,start=0x13b` to the end.

```
nano /flash/distroconfig.txt
```

Use `CTRL+X` to exit and make sure to save your changes.

Set `/flash` mountpoint back to read only mode:
```
mount -o remount,ro /flash
```

Reboot to enable Picade HAT X compatibility, at this point Picade HAT X should just emulate a regular input device.

Lakka's default menu toggle is assigned L3+R3.
This can change on Settings - Input.
Settings - Input - Hotkeys - Menu Toggle (Controller Combo)
L2+R2 might be good.

