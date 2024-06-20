#!/bin/bash
ntp_servers="192.168.1.60"

if [ -n "$1" ]; then
    ntp_servers=$1
fi

ARCH=$(uname -m)

if [ "$ARCH" == "x86_64" ]; then
    echo "Detected architecture: x86_64"
    sudo docker load -i docker-images/ntp_x86.tar
    chmod +x run_x86.sh
    ./run_x86.sh $ntp_servers
    # sudo NTP_SERVERS="$ntp_servers" docker-compose up --force-recreate
elif [ "$ARCH" == "aarch64" ]; then
    echo "Detected architecture: aarch64"
    sudo docker load -i docker-images/ntp_arm64.tar
    chmod +x run_arm64.sh
    ./run_arm64.sh $ntp_servers
    # sudo NTP_SERVERS="$ntp_servers" docker-compose -f docker-compose-arm64.yml up --force-recreate
else
    echo "Detected architecture: $ARCH"
    sudo docker load -i docker-images/ntp_arm64.tar
    chmod +x run_arm64.sh
    ./run_arm64.sh $ntp_servers
    # sudo NTP_SERVERS="$ntp_servers" docker-compose -f docker-compose-arm64.yml up --force-recreate
fi