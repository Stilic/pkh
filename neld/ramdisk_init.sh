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

for file in /mnt/usr/*; do 
   if [[ "$file" == *.sqsh ]]
   then
       mount_dir="/$(basename $file | cut -d "," -f 1)"
       mkdir $mount_dir
       mount $file $mount_dir
       lower_dirs="$mount_dir:$lower_dirs"
   fi
done
mount -t overlay overlay -o lowerdir=${lower_dirs%?} /root/usr

# mount --bind /root/usr/lib /root/usr/lib64

mount --move /dev /root/dev
umount /proc

exec switch_root /root /sbin/init
