#!/bin/sh
rm -rf ramdisk
mkdir ramdisk
cd ramdisk
mkdir -p dev proc mnt root etc work ro/sys ro/dev ro/run ro/proc ro/var ro/tmp ro/etc
cp -a ../ram_root/* .
cp -a ../ramdisk_init.sh init
find . -print | cpio -o --format=newc | gzip -9 > ../ramdisk.cpio.gz
