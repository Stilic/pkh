#!/bin/sh
if ! [ $(id -u) = 0 ]; then
   echo Please run this script as root.
   exit 1
fi

cd .build/work

truncate -s 100G disk
mkfs.ext4 -F disk

mkdir mnt
mount disk mnt
cd mnt

mkdir -p boot/usr root home
cp ../rootfs.sqsh boot
cp ../../*.sqsh boot/usr

cd ..
umount mnt
