#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys

mount -t devtmpfs none /dev
mkdir -p /dev/pts
mount -t devpts none /dev/pts

mount -t tmpfs none /run

mount -r $(sed -e 's/^.*root=//' -e 's/ .*$//' /proc/cmdline) /mnt

for file in /mnt/*; do 
    if [[ "$file" == *.sqsh ]]
    then
        mount_dir="/$(basename $file | cut -d "," -f 1)"
        mkdir $mount_dir
        mount $file $mount_dir
        lower_dirs="$mount_dir:$lower_dirs"
    fi
done

mount -t overlay overlay -o lowerdir=/ro:${lower_dirs%?} /root

mount --move /proc /root/proc
mount --move /sys /root/sys
mount --move /dev /root/dev
mount --move /run /root/run

exec switch_root /root /sbin/init
