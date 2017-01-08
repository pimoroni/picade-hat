# Picade HAT

This repository contains the software you need to get started with your Picade HAT.

Before you continue, you should make sure that you're running the latest RetroPie, have your Pi connected to the internet and have a keyboard ready to run through the setup steps.

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

Setup will continue automatically. When it's finished you can return to EmulationStation by typing:

```
emulationstation
```

And bind your input as normal!

# Automatic Installation

* Clone this GitHub repository somewhere onto your Pi: `git clone https://github.com/pimoroni/picade-hat`

* Enter the new directory: `cd picade-hat`

* Run the installer: `sudo ./setup.sh`

* Enjoy!

# Manual Installation

Use one of the methods above unless you *really* know what you're doing. The below steps let you pick and choose/customise the install to your needs.

## Required Software

You'll need to install evdev first:

```
sudo dpkg -i dependencies/python-evdev_0.6.4-1_armhf.deb
```

## Input Daemon

You will need to install the Picade HAT "daemon", (picadehatd), this involves three files; the init script, a udev rule and the daemon itself:

```
sudo cp daemon/etc/init.d/picadehatd /etc/init.d/
sudo cp daemon/etc/udev/rules.d/10-picadehatd.rules /etc/udev/rules.d/
sudo cp daemon/usr/bin/picadehatd /usr/bin/
sudo systemctl daemon-reload
sudo systemctl enable picadehatd
sudo service picadehatd start
```

## Power-off Script

The shutdown daemon will watch Picade HAT's power button and call `sudo shutdown -h now` if it is held for 3 seconds.

In order for your Pi to fully power down, you will need to add a script into `/lib/systemd/system-shutdown/`

This script is provided for you, so you can just:

```
sudo cp daemon/lib/systemd/system-shutdown/picade-hat-poweroff /lib/systemd/system-shutdown/
```

And make sure it's executable with:

```
sudo chmod +x /lib/systemd/system-shutdown/picade-hat-poweroff
```

## Sound & Volume Control

You will need to configure some things to get functioning sound and volume control with Picade HAT. We're going to trick EmulationStation into thinking our new software mixer, needed to control the volume of the i2s audio, is the old "PCM" sound device your Pi would normally have.

First you need to edit `/boot/config.txt` so that regular audio is disabled and i2s is enabled, like so:

```
#dtparam=audio=on
dtoverlay=i2s-mmap
dtoverlay=hifiberry-dac
```

(Note, that's i2s-mmap, not i2c-mmap!)

Next, for volume control to work you need to edit `/etc/asound.conf`:

(Note: you can find this file in daemon/etc/asound.conf)

```
pcm.real {
  type hw
  card 0
  device 0
}

pcm.dmixer {
  type dmix
  ipc_key 1024
  ipc_perm 0666
  slave.pcm "real"
  slave {
    period_time 0
    period_size 1024
    buffer_size 8192
    rate 44100
  }
  bindings {
    0 0
    1 1
  }
}

ctl.dmixer {
  type hw
  card 0
}

pcm.softvol {
  type softvol
  slave.pcm "dmixer"
  control {
    name "PCM" # Masquerade as the default "PCM" sound device on Pi (for EmulationStation)
    card 0
   }
}

pcm.!default {
   type plug
   slave.pcm "softvol"
}
```

Although optional, it is also possible to control the volume in-game via dedicated buttons wired to bcm13 (decrease volume) and bcm26 (increase volume). If you opt to do so, you will need to copy over the `picade-mixvolume` script provided in this repository:

```
sudo cp daemon/usr/bin/picade-mixvolume /usr/bin/
```

And make sure it's executable with:

```
sudo chmod +x /usr/bin/picade-mixvolume
```

What this script does is passing commands to `amixer` and increase/decrease the volume in 10% increments. As such you will need to make sure `alsa-utils` is installed on your system (it should be by default in Retropie).

And, finally, reboot and configure your controls!
