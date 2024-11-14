#!/bin/bash

## Watch humble-bundle-nice-downloader folder for file changes and 
## pump out new .xpi files to custom firefox profile extensions folder 
## like there is no tomorrow
## 
## Stop it with Ctrl + Z

## Check if OS is GNU/Linux or exit

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Script runs only on GNU/Linux OS. Exiting..."
    exit
fi

while true;
 do 
   watch -n 3 -d -t -g ls -lR humble-bundle-nice-downloader &&
   cd humble-bundle-nice-downloader && \
   7z u ../firefox/fd2r40gx.firefox-testing-profile/extensions/\{e1ea7933-f4a5-4d96-8838-90950e98d093\}.xpi ./* -r && \
   cd ..
 done
