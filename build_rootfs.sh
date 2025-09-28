#!/bin/sh
# TEMP SCRIPT!!!
rm -rf rootfs rootfs.sqsh
mkdir rootfs

for package in neld/.cache/*
do
    [[ "$package" = "base,1.sqsh" ]] && continue
    unsquashfs -f -d rootfs "$package"
done

unsquashfs -f -d rootfs neld/.cache/base,1.sqsh
mksquashfs rootfs rootfs.sqsh -comp lzo -force-uid 0 -force-gid 0
