#!/usr/bin/env bash

# Get latest Firmata release
curl -s https://api.github.com/repos/balena-io/balena-fin-coprocessor-firmata/releases/latest \
| grep "browser_download_url.*hex" \
| cut -d : -f 2,3 \
| tr -d \" \
| wget -qi -

mv *.hex firmware/firmata-balena-latest.hex

# Start server
node index.js
