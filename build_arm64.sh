#!/bin/bash

# grab global variables
source vars_arm64

DOCKER=$(which docker)
BUILD_DATE=$(date -u '+%Y-%m-%dT%H:%M:%S%z')

# build image
$DOCKER build --pull                               \
              --tag ${IMAGE_NAME}                  \
              --build-arg BUILD_DATE=${BUILD_DATE} \
              -f Dockerfile.arm64                  \
              .
