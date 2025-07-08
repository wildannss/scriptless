#!/bin/bash

cd
if ! screen -list | grep -q "bekap"; then
    screen -dmSL wss-one_ws-g rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum wss-onedrive: ws-gdrive:
fi

exit 0