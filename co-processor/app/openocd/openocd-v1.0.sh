#!/bin/bash
echo "Unloading ftdi_sio module..."
modprobe -r ftdi_sio
echo "Unloaded FTDI module"
sleep 3
echo "Configuring FT2232H-56Q EEPROM..."
ftdi_eeprom --flash-eeprom /usr/src/app/openocd/config/balena-fin-v1.0-jtag.conf
sleep 3
openocd -f /usr/src/app/openocd/config/balena-fin-v1.0.cfg -f target/efm32.cfg
