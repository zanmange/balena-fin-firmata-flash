echo "toggling co-processor mux to flash mode..."
echo 41 > /sys/class/gpio/export && echo "out" > /sys/class/gpio/gpio41/direction && echo 1 > /sys/class/gpio/gpio41/value
sleep 3
chmod +x flash.sh
echo "Opening screen terminal"
screen -dmS ftdi_program  "./flash.sh"
echo "Opened screen terminal"
sleep 5
{ sleep 5; echo "reset"; echo "program firmware/bootloader.s37"; echo "program firmware/firmata.hex"; echo "reset run"; sleep 10; } | telnet localhost 4444
sleep 5
echo "RUN $ node main.js, to start firmata checks"
tail -f /dev/null
