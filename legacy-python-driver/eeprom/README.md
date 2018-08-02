# EEPROM

Pimoroni HAT boards ship with a pre-programmed EEPROM, so most users will never need to worry about the resources included in this directory. From time to time however we may make available a revised configuration that may improve our users experience.

**While it's safe to reflash a HAT EEPROM, we typically do not recommend doing so unless you are instructed to do so.**

To reflash a HAT EEPROM, the only thing you need is a Raspberry Pi B+/2/3 or Zero.

As long as you meet the above requirements and are using a fairly recent version of Raspbian then our ready-to-go script should do the rest for you. Just run:

```
./reflash.sh
``` 

After a short delay, you should be greeted with a message stating:
'product ID match settings'

if that is not the case, please open an issue in this repository, posting the complete output of the script as well as the Pi and OS you are using and we'll try to advise.
