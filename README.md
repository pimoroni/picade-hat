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

You'll need to edit `/boot/config.txt` so that regular audio is disabled and i2s is enabled, like so:

```
#dtparam=audio=on
dtoverlay=i2s-mmap
dtoverlay=hifiberry-dac
```

Next edit `/etc/asound.conf`:

```
pcm.dmixer { 
    type dmix 
    ipc_key 1024
    ipc_key_add_uid false
    ipc_perm 0666			# mixing for all users
    slave { 
        pcm "hw:0,0" 
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

pcm.dsp0 { 
    type plug 
    slave.pcm "dmixer" 
} 

pcm.!default { 
    type plug 
    slave.pcm "dmixer" 
} 

pcm.default { 
   type plug 
   slave.pcm "dmixer" 
} 

ctl.mixer0 { 
    type hw 
    card 0 
}
```

And set up the right software:

```bash
sudo apt-get --purge autoremove pulseaudio

sudo apt-get remove jack-daemon

sudo apt-get install mpd mpc pianobar alsa-base alsa-oss alsa-tools alsa-utils alsaplayer-alsa alsaplayer-common gstreamer0.10-alsa gstreamer1.0-alsa alsa-oss oss-compat libsmartcols1 jackd libjack-jackd2-0:armhf qjackctl esound-common libasound2:armhf libasound2-data libasound2-plugins libsoundtouch0:armhf libtext-soundex-perl libsdl-mixer1.2:armhf pimixer
```
