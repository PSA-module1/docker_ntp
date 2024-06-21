#!/bin/bash
ntp_servers="192.168.1.60"

if [ -z "$1" ]; then
    echo "Usage: $0 <ntp_servers>"
else
    ntp_servers=$1
    echo "NTP_SERVERS: $ntp_servers"
fi

ARCH=$(uname -m)

if [ "$ARCH" == "x86_64" ]; then
    echo "Detected architecture: x86_64"
    sudo docker load -i docker-images/ntp_x86.tar
    sudo NTP_SERVERS="$ntp_servers" docker-compose up --force-recreate
elif [ "$ARCH" == "aarch64" ]; then
    echo "Detected architecture: aarch64"
    sudo docker load -i docker-images/ntp_arm64.tar
    sudo NTP_SERVERS="$ntp_servers" docker-compose -f docker-compose-arm64.yml up --force-recreate
else
    echo "Detected architecture: $ARCH"
    sudo docker load -i docker-images/ntp_arm64.tar
    sudo NTP_SERVERS="$ntp_servers" docker-compose -f docker-compose-arm64.yml up --force-recreate
fi