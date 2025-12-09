#!/bin/bash

set -e

# Load configuration
. ./config

# Create a special linux container to run ./build_img script from since it uses a bunch of linux-only tools which are not available on MacOS
docker build -t erofs-runner --platform=linux/amd64 -f erofs_runner/Dockerfile .

# execute build_img.sh inside the Linux container
docker run --rm -v /var/run/docker.sock:/var/run/docker.sock -v "$PWD":/workspace -w /workspace erofs-runner ./build_img.sh

# Deploy an instance
kraft cloud deploy -p 443:80 -M 512 .
