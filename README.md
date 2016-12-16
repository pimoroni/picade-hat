# Picade HAT

This repository contains the software you need to get started with your Picade HAT.

Before you continue, you should make sure that you're running the latest RetroPie, have your Pi connected to the internet and have a keyboard ready to run through the setup steps.

#Automatic Installation

* Boot your Pi with RetroPie as normal and wait for EmulationStation to load

* Hit F4 to exit EmulationStation

* Type: `git clone https://github.com/pimoroni/picade-hat`

* Enter the new directory: `cd picade-hat`

* Run the installer: `sudo ./setup.sh`

# Manual Installation

Clone this GitHub repository somewhere onto your Pi.

## Input Daemon

You will need to start up the `picade-hat-daemon.py` script at boot, the best way to do this is with cron.

Run `crontab -e`, pick your preferred editor and then add the line `@reboot sudo /path/to/picade-hat-daemon.py`

## Power-off Script

The shutdown daemon will watch Picade HAT's power button and call `sudo shutdown -h now` if it is held for 3 seconds.

In order for your Pi to fully power down, you will need to add a script into `/lib/systemd/system-shutdown/`

This script is provided in the `scripts` directory, so you can just:

```
sudo cp scripts/picade-hat-poweroff /lib/systemd/system-shutdown
```

And make sure it's executable with:

```
sudo chmod +x /lib/systemd/system-shutdown
```

## Sound & Volume Control

You will need to configure some things to get functioning sound and volume control with Picade HAT. We're going to trick EmulationStation into thinking our new software mixer, needed to control the volume of the i2s audio, is the old "PCM" sound device your Pi would normally have.

First you need to edit `/boot/config.txt` so that regular audio is disabled and i2s is enabled, like so:

```
#dtparam=audio=on
dtoverlay=i2s-mmap
dtoverlay=hifiberry-dac
```

You can use our pHAT DAC one-line installer to perform the above steps if you'd like:

```
\curl -sS https://get.pimoroni.com/phatdac | bash
```

Next, for volume control to work you need to edit `/etc/asound.conf`:

(Note: you can find this file in daemon/etc/asound.conf)

```
# the sound card
pcm.real {
  type hw
  card 0
  device 0
}

#support  the ipc stuff is needed for permissions, etc.
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

# software volume
pcm.softvol {
  type softvol
  slave.pcm "dmixer"
  control {
    name "PCM"
    card 0
   }
}

# input
pcm.input {
   type dsnoop
   ipc_key 3129398
   ipc_key_add_uid false
   ipc_perm 0660
   slave.pcm "810"
}

# duplex device
pcm.duplex {
   type asym
   playback.pcm "softvol"
   capture.pcm "input"
}

# default devices
pcm.!default {
   type plug
   slave.pcm "duplex"
}
```
