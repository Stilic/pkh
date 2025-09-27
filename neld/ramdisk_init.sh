#!/bin/sh
mount -t devtmpfs none /dev
mount -t proc none /proc

mount $(sed -e 's/^.*root=//' -e 's/ .*$//' /proc/cmdline) /mnt

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

mount --bind /mnt/home /root/home
mount --bind /mnt/root /root/root
mount -t overlay overlay -o lowerdir=/root/etc,upperdir=/etc,workdir=/work /root/etc

mount --move /dev /root/dev
umount /proc

mount --bind /root/lib /root/lib64

mount -t tmpfs var /root/var
mkdir /root/var/log /root/var/run /root/var/db

mount -t tmpfs tmp /root/tmp

exec switch_root /root /sbin/init
