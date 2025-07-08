#!/bin/bash

cd
if ! screen -list | grep -q "bekap"; then
    screen -dmSL wss-one_nxt rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum wss-onedrive: nxt:Drive/wss
fi

exit 0