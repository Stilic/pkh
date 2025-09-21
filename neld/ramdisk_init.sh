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
        mount_dir="/$(basename -s .sqsh $file)"
        mkdir $mount_dir
        mount $file $mount_dir
        lower_dirs="$mount_dir:$lower_dirs"
    fi
done
mkdir /merged
mount -t overlay overlay -o lowerdir=${lower_dirs%?} /merged

mount --move /proc /mnt/proc
mount --move /sys /mnt/sys
mount --move /dev /mnt/dev
mount --move /run /mnt/run

#exec switch_root /mnt /sbin/init
exec /bin/sh