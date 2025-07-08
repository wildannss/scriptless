#!/bin/bash

cd
if ! screen -list | grep -q "bekap"; then
    screen -dmSL ws_work_nxt rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum ws-onedrive_work: nxt:Drive/ws_work
fi

exit 0