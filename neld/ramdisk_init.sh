#!/bin/sh
mount -t devtmpfs none /dev
mount -t proc none /proc
mount -t tmpfs none /tmp -o mode=1777
mount -t sysfs none /sys
mkdir -p /dev/pts
mount -t devpts none /dev/pts
mount $(sed -e 's/^.*root=//' -e 's/ .*$//' /proc/cmdline) /mnt
mount --move /dev /mnt/dev
mount --move /sys /mnt/sys
mount --move /proc /mnt/proc
mount --move /tmp /mnt/tmp
exec switch_root /mnt /sbin/init
