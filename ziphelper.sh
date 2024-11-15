#!/bin/bash

## A script to watch humble-bundle-nice-download and pump out xpi file 
## after each file change.
## 
## Stop it with Ctrl + Z

## Check if OS is GNU/Linux or exit

if [[ "$OSTYPE" != "linux-gnu"* ]]; then
    echo "Script runs only on GNU/Linux OS. Exiting..."
    exit
fi

## Check if directory humble-bundle-nice-downloader exists or exit

if [[ ! -d humble-bundle-nice-downloader ]]; then
    echo "Directory humble-bundle-nice-downloader doesn't exist. Exiting..."
    echo ""
    echo "You should start \"yarn build-watch\" before running this script"
    exit
fi


while true;
 do 
   watch -n 3 -d -t -g ls -lR humble-bundle-nice-downloader &&
   cd humble-bundle-nice-downloader && \
   7z u ../firefox/fd2r40gx.firefox-testing-profile/extensions/\{e1ea7933-f4a5-4d96-8838-90950e98d093\}.xpi ./* -r && \
   cd ..
 done
