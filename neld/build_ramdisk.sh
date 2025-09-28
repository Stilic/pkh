#!/bin/sh
cd .build/work
rm -rf ramdisk
mkdir ramdisk
cd ramdisk
mkdir dev proc mnt ro root etc work
cp -ra ../ram_root/* .
cp -a ../../../ramdisk_init.sh init
find . -print | cpio -o --format=newc | gzip -9 > ../ramdisk.cpio.gz
