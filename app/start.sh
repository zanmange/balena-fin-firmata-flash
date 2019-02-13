echo "Unloading ftdi_sio module..."
modprobe -r ftdi_sio
echo "Unloaded FTDI module"
sleep 3
chmod +x ftdi.sh
echo "Opening screen terminal"
screen -dmS ftdi_program  "./ftdi.sh"
echo "Opened screen terminal"
sleep 5
{ sleep 5; echo "reset"; echo "program firmware/bootloader.s37"; echo "program firmware/firmata.hex"; echo "reset run"; sleep 10; } | telnet localhost 4444
echo "Loading FTDI module..."
modprobe ftdi_sio
sleep 5
echo "RUN $ node main.js, to start firmata checks"
tail -f /dev/null