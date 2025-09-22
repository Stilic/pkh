#!/bin/sh
mount -t proc none /proc
mount -t sysfs none /sys

mount -t devtmpfs none /dev
mkdir -p /dev/pts
mount -t devpts none /dev/pts

mount -t tmpfs none /run
mkdir /run/ow

mount $(sed -e 's/^.*root=//' -e 's/ .*$//' /proc/cmdline) /mnt
mkdir -p /mnt/var/var/log /mnt/work

for file in /mnt/*; do 
    if [[ "$file" == *.sqsh ]]
    then
        mount_dir="/$(basename $file | cut -d "," -f 1)"
        mkdir $mount_dir
        mount $file $mount_dir
        lower_dirs="$mount_dir:$lower_dirs"
    fi
done

mount -t overlay overlay -o lowerdir=/ro:${lower_dirs%?},upperdir=/mnt/var,workdir=/mnt/work /fs

mount --move /proc /fs/proc
mount --move /sys /fs/sys
mount --move /dev /fs/dev
mount --move /run /fs/run

exec switch_root /fs /sbin/init
