#!/usr/bin/env python

import RPi.GPIO as GPIO
import sys, os, subprocess, tempfile, shlex

EEPROM_TYPE = '24c32'
GPIO_WRITE_PROTECT = 7
TOOLS_DIR = './'

eepflash = os.path.join(TOOLS_DIR, 'eepflash')
eepmake  = os.path.join(TOOLS_DIR, 'eepmake')

def write_unlock():
    GPIO.setwarnings(False)
    GPIO.setmode(GPIO.BCM)
    GPIO.setup(GPIO_WRITE_PROTECT,  GPIO.OUT)
    GPIO.output(GPIO_WRITE_PROTECT, GPIO.LOW)

def write_lock():
    GPIO.cleanup()

def write_uuid(settings):
    temp_eep_id, temp_eep_path = tempfile.mkstemp()

    devnull = sys.stdout # open('/dev/null','w')

    write_unlock()
    subprocess.call([eepmake, settings, temp_eep_path], stderr=devnull, stdout=devnull)
    subprocess.call([eepflash,'-w','-t=' + EEPROM_TYPE,'-f=' + temp_eep_path], stderr=devnull, stdout=devnull)
    write_lock()

    os.close(temp_eep_id)
    os.remove(temp_eep_path)

def write_eeprom(settings, dtbo):
    temp_eep_id, temp_eep_path = tempfile.mkstemp()

    devnull = sys.stdout # open('/dev/null','w')

    write_unlock()
    subprocess.call([eepmake, settings, temp_eep_path, dtbo], stderr=devnull, stdout=devnull)
    subprocess.call([eepflash,'-w','-t=' + EEPROM_TYPE,'-f=' + temp_eep_path], stderr=devnull, stdout=devnull)
    write_lock()

    os.close(temp_eep_id)
    os.remove(temp_eep_path)

def dump_eeprom():
    data = {}
    gpio = {}

    eepdump  = os.path.join(TOOLS_DIR, 'eepdump')

    temp_eeprom_id, temp_eeprom_path = tempfile.mkstemp()
    temp_dump_id,   temp_dump_path   = tempfile.mkstemp()

    devnull = open('/dev/null','w')

    subprocess.call([eepflash,'-r','-t=' + EEPROM_TYPE,'-f=' + temp_eeprom_path], stderr=devnull, stdout=devnull, shell=False)
    subprocess.call([eepdump,temp_eeprom_path,temp_dump_path], stderr=devnull, stdout=devnull)

    with open(temp_dump_path,'r') as file:
        for line in file.readlines():
            #print(line)
            if not line.strip().startswith("#"):
                d = shlex.split(line)
                if len(d) >= 2:
                    if d[0] == 'setgpio':
                        gpio[int(d[1])] = d[2:]
                    else:
                        data[d[0]] = d[1]

    os.close(temp_dump_id)
    os.remove(temp_dump_path)
    os.close(temp_eeprom_id)
    os.remove(temp_eeprom_path)

    return data, gpio

def display_data(data, items):
    for item in items:
        if item in data.keys():
            print("{}: {}".format(item, data[item]))

def display_all(data, gpio):
    display_data(data, ['product','vendor','product_uuid','product_id','product_ver'])

    for pin in gpio.keys():
        print("GPIO {}: {}".format(pin, gpio[pin][0]))

if __name__ == '__main__':
    if len(sys.argv) > 1:
        action = sys.argv[1]
        if action == 'write' and len(sys.argv) > 2:
            data, gpio = dump_eeprom()
            settings = sys.argv[2]
            blob = False
            force = False
            if len(sys.argv) > 4 and sys.argv[4] == 'force':
				force = True
				blob = True
				dtbo = sys.argv[3]
            elif len(sys.argv) > 3 and sys.argv[3] == 'force':
                force = True
            elif len(sys.argv) > 3 and sys.argv[3] != 'force':
                force = False
                blob = False
                dtbo = sys.argv[3]
            if not 'product_uuid' in data or force:
                if blob:
	                dtbo = sys.argv[3]
	                write_eeprom(settings, dtbo)
                else:
	                write_uuid(settings)
            else:
                print("This board already has a UUID!")
                display_data(data, ['product','product_uuid'])
        if action == 'read' and len(sys.argv) > 2:
            data, gpio = dump_eeprom()
            key = sys.argv[2]
            if key == 'all':
                display_all(data, gpio)
                exit(0)
            if key in data.keys():
                print(data[key])
                exit(0)
