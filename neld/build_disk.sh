#!/bin/sh
if [ "$EUID" -ne 0 ]
then
    echo Please run this script as root.
    exit
fi
truncate -s 100g disk
mkfs.ext4 -F disk
mount disk /mnt
mkdir -p /mnt/proc /mnt/sys /mnt/dev /mnt/mnt /mnt/root /mnt/etc /mnt/lib /mnt/sbin /mnt/bin /mnt/tmp /mnt/usr /mnt/run /mnt/var/run /mnt/var/log/init
cp -ra root/* /mnt
cp -ra base/* /mnt
umount /mnt
