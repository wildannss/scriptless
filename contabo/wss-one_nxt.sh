#!/bin/bash

cd
if ! screen -list | grep -q "wss-one_nxt"; then
    screen -dmSL wss-one_nxt rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum wss-onedrive: nxt:Drive/wss
fi

exit 0