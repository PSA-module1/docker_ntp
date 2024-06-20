#!/bin/bash
ntp_servers="192.168.1.60"

# grab global variables
CONTAINER_NAME="ntp"
IMAGE_NAME="clothooo/docker-ntp"
DOCKER=$(which docker)

# function to check if container is running
function check_container() {
    $DOCKER ps -a --filter "name=${CONTAINER_NAME}" --format "{{.ID}}"
}

# function to start new docker container
function start_container() {
    $DOCKER run --name=${CONTAINER_NAME}             \
    --restart always \
    --net=host \
    --read-only=true \
    --tmpfs /etc/chrony:rw,mode=1750 \
    --tmpfs /run/chrony:rw,mode=1750 \
    --tmpfs /var/lib/chrony:rw,mode=1750 \
    --cap-add SYS_TIME \
    -e NTP_SERVERS="${ntp_servers}" \
    -e HOSTNAME=${HOSTNAME:-127.127.1.1} \
    -e LOG_LEVEL=0 \
    -p 123:123/udp \
    ${IMAGE_NAME}:arm64
}

if [ -z "$1" ]; then
    echo "Usage: $0 <ntp_servers>"
else
    ntp_servers=$1
    echo "NTP_SERVERS: $ntp_servers"
fi

# check if docker container with same name is already running.
if [ "$(check_container)" != "" ]; then
  # container found...
  # 1) rename existing container
  $DOCKER rename ${CONTAINER_NAME} "${CONTAINER_NAME}_orig" > /dev/null 2>&1
  # 2) stop exiting container
  $DOCKER stop "${CONTAINER_NAME}_orig" > /dev/null 2>&1
  # 3) start new container
  start_container
  # 4) remover existing container
  if [ "$(check_container)" != "" ]; then
    $DOCKER rm "${CONTAINER_NAME}_orig" > /dev/null 2>&1
  fi

  # finally, lets clean up old docker images
  $DOCKER rmi $($DOCKER images -q ${IMAGE_NAME}) > /dev/null 2>&1

# no docker container found. start a new one.
else
  start_container
fi