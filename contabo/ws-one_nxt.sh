#!/bin/bash

cd
if ! screen -list | grep -q "ws-one_nxt"; then
    screen -dmSL ws-one_nxt rclone copy --progress --drive-acknowledge-abuse --update --local-no-check-updated --ignore-checksum ws-onedrive: nxt:Drive/ws
fi

exit 0