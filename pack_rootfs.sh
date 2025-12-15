#!/bin/sh
cd neld/.rootfs
rm -rf work
mkdir work
cd work

mkdir rootfs
cd rootfs

mkdir -p sys dev run proc var tmp usr/lib64 root home etc

for package in ../../*.sqsh
do
    [[ $(basename "$package") = "base,1.sqsh" ]] && continue
    unsquashfs -f -d . "$package"
done

if [ "$1" -eq 1 ]; then
    cp /usr/lib/libgmp* lib
    rm lib/libgmp.la
fi

unsquashfs -f -d . ../../base,1.sqsh
mksquashfs . ../rootfs.sqsh -comp lzo -force-uid 0 -force-gid 0
