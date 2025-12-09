#!/bin/sh

# This script uses erofs to create a root file system. If you are running Linux - you can execute this script as is. Otherwise (MacOS) - execute this script using erofs_runner container

# Stop execution on errors
set -e

. ./config
    
# Build the root file system
rm -rf ./.rootfs || true
docker build --platform=linux/amd64 -t "$name" -f Dockerfile .

docker rm cnt-"$name" || true
docker create --name cnt-"$name" "$name" /bin/sh
docker cp cnt-"$name":/ /tmp/.rootfs

rm -f "./initrd" || true
mkfs.erofs --all-root -d2 -E noinline_data "./initrd" /tmp/.rootfs
mv /tmp/.rootfs ./.rootfs

# make rootfs open-to-write
chmod -R 777 ./.rootfs
# make initrd open-to-write
chmod -R 777 "./initrd"

echo "Completed building image"


