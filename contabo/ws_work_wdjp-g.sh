#!/bin/bash

cd
if ! screen -list | grep -q "bekap"; then
    screen -dmSL ws_work_wdjp-g rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum ws-onedrive_work: wdjp-gdrive:
fi

exit 0