#!/bin/sh
mount -t devtmpfs tmpfs /dev
mkdir -p /dev/pts /dev/shm
mount -t tmpfs -o nodev,nosuid tmpfs /dev/shm
mount -t devpts -o gid=5 devpts /dev/pts
mount -t proc proc /proc

mount $(sed -e 's/^.*root=//' -e 's/ .*$//' /proc/cmdline) /mnt
mount /mnt/rootfs.sqsh /root
mount --bind /mnt/home /root/home
mount --bind /mnt/root /root/root
mount -t overlay overlay -o lowerdir=/root/etc,upperdir=/etc,workdir=/work /root/etc

mount -t tmpfs ro /ro
mkdir /ro/bin
ln -s ../../bin/env /ro/bin/env

for file in /mnt/usr/*; do
   if [[ "$file" == *.sqsh ]]
   then
       mount_dir="/$(basename $file | cut -d "," -f 1)"
       mkdir $mount_dir
       mount $file $mount_dir
       lower_dirs="$mount_dir:$lower_dirs"
   fi
done

mount -t overlay overlay -o lowerdir=/ro:${lower_dirs%?} /root/usr

mount -t tmpfs tmp /root/tmp
mount -t tmpfs var /root/var
mkdir /root/var/log /root/var/run /root/var/db

mount --move /dev /root/dev
umount /proc

exec switch_root /root /sbin/init
