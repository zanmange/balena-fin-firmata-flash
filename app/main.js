const Telnet = require('telnet-client');
const telnet_params = {
  host: '127.0.0.1',
  port: 4444
};
const connection = new Telnet();
const {
  spawn
} = require('child_process');
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

    connection.connect(telnet_params)
      .then(function(prompt) {
        connection.exec("reset halt")
          .then(function(res) {
            console.log('promises result:', res);
          });
      }, function(error) {
        console.log('promises reject:', error);
      });
  }
});
