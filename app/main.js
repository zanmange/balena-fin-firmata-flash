const Firmata = require("firmata");
const port = process.env.SERIALPORT || "/dev/ttyS0";
const board = new Firmata(port);

board.settings.skipCapabilities = true;
console.log("Checking Firmata version...");

board.on("queryfirmware", () => {
  "use strict";
  // Encoded terminal text colors, i.e. green is \x1b[32m
  console.log('\x1b[32m%s\x1b[0m', board.firmware.name + "  ✔ firmware name");
  console.log('\x1b[32m%s\x1b[0m', board.firmware.version.major + "." + board.firmware.version.minor + "              ✔ firmata version");
});

board.on("ready", function() {
  "use strict";
  const LED = 14;

  const DIGITAL_OUT = 2;
  let state = 0;
  let DIGITAL_PASS = false;

  const ANALOG_OUT = 4;
  const ANALOG_IN = 3;
  let ANALOG_PASS = false;
  const analogs = [ANALOG_IN];
  let i = 0;

  console.log('\x1b[32m%s\x1b[0m', "balenaFin        ✔ ready");
  console.log("Starting DIGITAL I/O check...");

  this.pinMode(LED, board.MODES.OUTPUT);
  this.pinMode(DIGITAL_OUT, board.MODES.OUTPUT);
  this.digitalWrite(DIGITAL_OUT, 1);

  const states = {
    1: 0
  };

  if (process.env.SLEEP) {
    this.sysexCommand(configSleep(5,10));
  };

  Object.keys(states).forEach(function(pin) {
    pin = +pin;
    this.pinMode(pin, board.MODES.INPUT);
    this.digitalRead(pin, function(value) {
      console.log("DIGITAL_IN | Pin %d | Value %d", pin, value);
      if (value == 1) {
        DIGITAL_PASS = true;
      }
    });
  }, this);

  console.log("Starting ANALOG I/O check...");

  this.pinMode(ANALOG_OUT, board.MODES.PWM);

  analogs.forEach(function(pin) {
    pin = +pin;
    this.pinMode(pin, board.MODES.ANALOG);
    this.analogRead(pin, function(value) {
      if (value > 2000) {
        ANALOG_PASS = true;
      }
      // loops through duty cycles of PWM
      i = 10 + i;
      console.log("ANALOG_IN  | Pin %d | Value %d", pin, value);
      this.analogWrite(ANALOG_OUT, i);
      if (i >= 100) {
        i = 0;
      }
    });
  }, this);

  setInterval(() => {
    this.digitalWrite(LED, (state ^= 1));
    if (DIGITAL_PASS && ANALOG_PASS) {
      console.log('\x1b[32m%s\x1b[0m', "All checks passed ✔");
      process.exit();
    }
  }, 500);
});

process.on('SIGINT', function() {
  "use strict";
  console.log("Resetting Firmata");
  board.reset();
  process.exit();
});

function configSleep(delay,sleep) {
  console.log("Initiating Sleep command")
  // we want to represent the input as a 8-bytes array
  var byteArray = [0, 0, 0, 0];

  for ( var index = 0; index < byteArray.length; index ++ ) {
      var byte = sleep & 0xff;
      byteArray [ index ] = byte;
      sleep = (sleep - byte) / 256 ;
  }
  byteArray.splice(0, 0, 0x0B);
  byteArray.splice(1, 0, 0x01);  
  byteArray.splice(2, 0, delay);  
  console.log(byteArray)
  return byteArray;
};