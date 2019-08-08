#!/bin/bash

openocd -f interface/ftdi/ft232h-module-swd.cfg -f target/efm32.cfg
