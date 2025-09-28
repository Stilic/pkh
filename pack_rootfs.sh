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

unsquashfs -f -d . ../../base,1.sqsh
mksquashfs . ../rootfs.sqsh -comp lzo -force-uid 0 -force-gid 0
