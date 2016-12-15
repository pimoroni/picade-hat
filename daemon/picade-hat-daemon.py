#!/usr/bin/env python

import time
import signal
import os
import sys
from threading import Timer

from evdev import uinput, UInput, ecodes as e
import RPi.GPIO as gpio

#time.sleep(30)

os.system("sudo modprobe uinput")

BOUNCE_TIME = 0.01 # Debounce time in seconds
SHUTDOWN_HOLD_TIME = 3 # Time in seconds that power button must be held

SHUTDOWN = 4
BUTTON_POWER = 17

UP = 12
DOWN = 6
LEFT = 20
RIGHT = 16

BUTTON1 = 5
BUTTON2 = 11
BUTTON3 = 8
BUTTON4 = 25
BUTTON5 = 9
BUTTON6 = 10

ENTER = 27
ESCAPE = 22
COIN = 23
START= 24

BUTTONS = [ENTER,ESCAPE,COIN,START,BUTTON1,BUTTON2,BUTTON3,BUTTON4,BUTTON5,BUTTON6,UP,DOWN,LEFT,RIGHT]

KEYS = {
    ENTER: e.KEY_ENTER,
    ESCAPE: e.KEY_ESC,
    COIN: e.KEY_S,
    START: e.KEY_C,
    UP: e.KEY_UP,
    DOWN: e.KEY_DOWN,
    LEFT: e.KEY_LEFT,
    RIGHT: e.KEY_RIGHT,
    BUTTON1: e.KEY_LEFTCTRL,
    BUTTON2: e.KEY_LEFTALT,
    BUTTON3: e.KEY_SPACE,
    BUTTON4: e.KEY_LEFTSHIFT,
    BUTTON5: e.KEY_Z,
    BUTTON6: e.KEY_X
}

states = [False for b in BUTTONS]

shutdown_timer = None

gpio.setmode(gpio.BCM)
gpio.setwarnings(False)
gpio.setup(BUTTONS, gpio.IN, pull_up_down=gpio.PUD_UP)
gpio.setup(BUTTON_POWER, gpio.IN, pull_up_down=gpio.PUD_UP)

try:
    ui = UInput()

except uinput.UInputError as e:
    print(e.message)
    print("Have you tried running as root? sudo {}".format(sys.argv[0]))
    sys.exit(0)

def handle_button(pin):
    key = KEYS[pin]
    time.sleep(BOUNCE_TIME)
    state = 0 if gpio.input(pin) else 1
    ui.write(e.EV_KEY, key, state)
    ui.syn()
    print("Pin: {}, KeyCode: {}, Event: {}".format(pin, key, 'press' if state else 'release'))

def perform_shutdown():
    print("Shutting down...")
    os.system("sudo shutdown -h now")

def handle_shutdown(pin):
    global shutdown_timer

    time.sleep(BOUNCE_TIME)
    state = 0 if gpio.input(pin) else 1

    print("Power button: {}".format('pressed' if state else 'released'))

    if state and shutdown_timer is None:
        shutdown_timer = Timer(SHUTDOWN_HOLD_TIME, perform_shutdown)
        shutdown_timer.start()

    elif not state and shutdown_timer is not None:
        shutdown_timer.cancel()
        shutdown_timer = None

for button in BUTTONS:
    gpio.add_event_detect(button, gpio.BOTH, callback=handle_button, bouncetime=1)

gpio.add_event_detect(BUTTON_POWER, gpio.BOTH, callback=handle_shutdown, bouncetime=1)

print("Picade HAT daemon running...")

try:
    signal.pause()
except KeyboardInterrupt:
    pass

print("Picade HAT daemon shutting down...")

ui.close()