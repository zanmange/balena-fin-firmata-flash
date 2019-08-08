#!/bin/bash
echo "Unloading ftdi_sio module..."
modprobe -r ftdi_sio
echo "Unloaded FTDI module"
sleep 3
openocd -f interface/ftdi/ft232h-module-swd.cfg -f target/efm32.cfg
