#!/bin/sh
if ! [ $(id -u) = 0 ]; then
   echo Please run this script as root.
   exit 1
fi
truncate -s 100G disk
mkfs.ext4 -F disk
mount disk /mnt
cp .cache/* /mnt
umount /mnt
