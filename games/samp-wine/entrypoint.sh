#!/bin/bash
cd /home/container

# Make internal Docker IP address available
export INTERNAL_IP=`ip route get 1 | awk '{print $(NF-2);exit}'`

# Ganti startup variable {{VAR}} -> $VAR
MODIFIED_STARTUP=$(echo -e ${STARTUP} | sed -e 's/{{/${/g' -e 's/}}/}/g')
echo ":/home/container$ ${MODIFIED_STARTUP}"

# Jalanin server dengan Wine
eval ${MODIFIED_STARTUP}
