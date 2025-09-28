#!/bin/sh
cd neld/.rootfs
rm -rf work
mkdir work
cd work

mkdir rootfs

for package in ../*.sqsh
do
    [[ $(basename "$package") = "base,1.sqsh" ]] && continue
    unsquashfs -f -d rootfs "$package"
done

unsquashfs -f -d rootfs ../base,1.sqsh
mksquashfs rootfs rootfs.sqsh -comp lzo -force-uid 0 -force-gid 0
