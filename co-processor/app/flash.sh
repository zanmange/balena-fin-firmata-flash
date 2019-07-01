#!/bin/bash

FW=$1
echo "Opening screen terminal"
screen -dmS swd_program  "./openocd.sh"
sleep 5
  { sleep 5; echo "reset halt"; echo "program firmware/bootloader.s37"; sleep 5; echo "reset halt"; echo "program firmware/$FW"; echo "reset run"; sleep 10; } | telnet localhost 4444
sleep 5
echo "closing the openocd process..."
kill $(ps aux | grep '[S]CREEN -dmS swd_program ./openocd.sh' | awk '{print $2}')
sleep 5
echo "flashing complete"
