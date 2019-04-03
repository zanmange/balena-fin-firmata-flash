const et = require("expect-telnet");
const { spawn } = require('child_process');
const Gpio = require('onoff').Gpio;
const mux = new Gpio(41, 'out');
let openocd;

mux.write(1, (err) => {
  "use strict";
  if (err) {
    console.error(err);
  } else {
    openocd = spawn('openocd', ['-f', 'balena-fin-v1.1.cfg']);
    openocd.stdout.on('data', (data) => {
      console.log(`stdout: ${data}`);
    });
    openocd.stderr.on('data', (data) => {
      console.log(`stderr: ${data}`);
    });
    openocd.on('close', (code) => {
      console.log(`child process exited with code ${code}`);
    });

    et("127.0.0.1:4444", [{
      expect: "",
      send: "reset halt\r"
    },{
      expect: "",
      send: "program firmware/firmata.hex\r"
    },{
      expect: "",
      send: "reset run\r"
    }], {
      exit: true
    }, (err) => {
      if (err) console.error(err);
    });
  }
});
