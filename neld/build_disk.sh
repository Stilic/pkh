#!/bin/sh
if [ "$EUID" -ne 0 ]
then
    echo Please run this script as root.
    exit
fi
truncate -s 1GB disk
mkfs.ext4 -F disk
mount disk /mnt
mkdir -p /mnt/dev /mnt/proc /mnt/sys /mnt/mnt /mnt/etc /mnt/lib /mnt/sbin /mnt/bin /mnt/tmp /mnt/usr /mnt/var/log/init
cp -ra root/* /mnt
cp -ra base/* /mnt
umount /mnt
