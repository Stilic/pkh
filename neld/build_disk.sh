#!/bin/sh
if ! [ $(id -u) = 0 ]; then
   echo Please run this script as root.
   exit 1
fi
truncate -s 100G disk
mkfs.ext4 -F disk
mkdir mnt
mount disk mnt
mount -o loop disk mnt
mkdir -p mnt/home/root
find .cache ! -name busybox-static* -exec cp -t mnt {} +
umount mnt
