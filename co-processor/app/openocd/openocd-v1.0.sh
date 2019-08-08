#!/bin/bash
sleep 2
echo "Unloading ftdi_sio module..."
modprobe -r ftdi_sio
echo "Unloaded FTDI module"
sleep 1
echo "Configuring FT2232H-56Q EEPROM..."
ftdi_eeprom --flash-eeprom /usr/src/app/openocd/config/balena-fin-v1.0-jtag.conf
openocd -f /usr/src/app/openocd/config/balena-fin-v1.0.cfg -f target/efm32.cfg
