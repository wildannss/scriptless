#!/bin/bash

cd
if ! screen -list | grep -q "ws_work_nxt"; then
    screen -dmSL ws_work_nxt rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum ws-onedrive_work: nxt:Drive/ws_work
fi

exit 0