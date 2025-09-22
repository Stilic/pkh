#!/bin/sh
rm -rf ramdisk
mkdir ramdisk
cd ramdisk
mkdir -p proc sys run mnt sbin bin tmp usr fs ro/proc ro/sys ro/dev ro/run
cp -a ../ram_root/* .
cp -a ../ramdisk_init.sh init
find . -print | cpio -o --format=newc | gzip -9 > ../ramdisk.cpio.gz
