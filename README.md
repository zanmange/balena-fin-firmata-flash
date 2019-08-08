# balena-fin-firmata-flash

This is a balena application that allows to flash the balenaFin Coprocessor with the latest version of the [balenaFin Firmata](https://github.com/balena-io/balena-fin-coprocessor-firmata). For more information about Firmata, check out the official [repo](https://github.com/firmata/protocol). **This currently supports the balenaFin v1.0** (v1.1 will soon be supported as well).

### co-processor REST interface (port 1337)

default port: `1337`

**NOTE:** while having this interface exposed to the outside is useful for development (you can consume this interface from your laptop in order to flash and test your balenaFin) we highly suggest to change the docker-compose configuration for the co-processor service ( `network_mode: host` ) once your own business logic has this interface implemented so that only the services you deploy on the device will be able to access it.

##### flash firmware

_POST_ `/v1/flash/firmware`

flashes the given firmware name from the service fs ( ie `firmware/firmata-balena-0.0.2.hex` ). The co-processor service has a volume (`/data`) that you can add to other service and use as a way to share different firmwares to flash.

##### sleep

_POST_ `/v1/sleep/:delay/:timeout`

triggers the balenaFin power saving mode.
* `delay` (integer) is the amount of seconds the co-processor will wait before shutting down the linux side (CM3/CM3+)
* `timeout` (integer) is the amount of seconds the co-processor will keep the linux side (CM3/CM3+) shut down before bringing it back up. There is a limit of 97 years (3,058,992,000 seconds) as the max value the co-processor can handle
