#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys

mount -t devtmpfs none /dev
mkdir -p /dev/pts
mount -t devpts none /dev/pts

mount -t tmpfs none /run

mount -r $(sed -e 's/^.*root=//' -e 's/ .*$//' /proc/cmdline) /mnt

mount --move /proc /mnt/proc
mount --move /sys /mnt/sys
mount --move /dev /mnt/dev
mount --move /run /mnt/run

exec switch_root /mnt /sbin/init
