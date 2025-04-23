#!/bin/sh
if [ "$EUID" -ne 0 ]
then
    echo Please run this script as root.
    exit
fi
mount disk /mnt
rm -rf /mnt/dev /mnt/proc /mnt/sys /mnt/mnt /mnt/etc /mnt/lib /mnt/sbin /mnt/bin /mnt/tmp /mnt/usr /mnt/run /mnt/var
mkdir -p /mnt/dev /mnt/proc /mnt/sys /mnt/mnt /mnt/etc /mnt/lib /mnt/sbin /mnt/bin /mnt/tmp /mnt/usr /mnt/run /mnt/var/run /mnt/var/log/init
cp -ra root/* /mnt
cp -ra base/* /mnt
umount /mnt
