#!/bin/sh
# TEMP SCRIPT!!!
rm -rf rootfs
mkdir -p rootfs

for package in neld/.cache/*
do
    [[ "$(basename "$package")" = "base,1.sqsh" ]] && continue
    unsquashfs -d rootfs "$package*"
done

cp -ra pickle-linux/main/base/.build/filesystem/* rootfs
unsquashfs -d rootfs neld/.cache/base,1.sqsh
mksquashfs rootfs rootfs.sqsh -comp lzo -force-uid 0 -force-gid 0
