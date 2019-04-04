if [ -z "$STOP" ]; then
  echo "toggling co-processor mux to flash mode..."
  if [[ -e /sys/class/gpio/gpio41 ]]; then
    echo "mux pin already in use, will not export but just set it..."
  else
    echo 41 > /sys/class/gpio/export
  fi
  sleep 1
  echo "out" > /sys/class/gpio/gpio41/direction && sleep 1 && echo 1 > /sys/class/gpio/gpio41/value
  sleep 1
  echo "Opening screen terminal"
  screen -dmS swd_program  "./openocd.sh"
  sleep 5
  if [ -z "$FIRMWARE" ]; then
    { sleep 5; echo "reset halt"; echo "program firmware/bootloader.s37"; sleep 5; echo "reset halt"; echo "program firmware/firmata.hex"; echo "reset run"; sleep 10; } | telnet localhost 4444
  else
    { sleep 5; echo "reset halt"; echo "program firmware/bootloader.s37"; sleep 5; echo "reset halt"; echo "program $FIRMWARE"; echo "reset run"; sleep 10; } | telnet localhost 4444
  fi
  sleep 5
  echo "WARNING!! kill any openocd process first, then toggle GPIO41 LOW via echo 0 > /sys/class/gpio/gpio41/value then RUN $ node main.js, to start firmata checks"
fi
tail -f /dev/null
