#!/bin/bash

FW=$1
REV=$2
echo "Opening screen terminal for flashing $FW to balenaFin v$REV"
case $REV in
  1.0)
    screen -dmS swd_program  "openocd -f interface/ftdi/2232h-cp.cfg -f target/efm32.cfg"
    ;;
  1.1)
    screen -dmS swd_program  "./openocd.sh"
    ;;
  *)
    echo "ERROR: unknown balenaFin revision"
    exit 1
    ;;
esac
sleep 5
  { sleep 5; echo "reset halt"; echo "program firmware/bootloader.s37"; sleep 5; echo "reset halt"; echo "program firmware/$FW"; echo "reset run"; sleep 10; } | telnet localhost 4444
sleep 5
echo "closing the openocd process..."
kill $(ps aux | grep '[S]CREEN -dmS swd_program ./openocd.sh' | awk '{print $2}')
sleep 5
echo "flashing complete"
