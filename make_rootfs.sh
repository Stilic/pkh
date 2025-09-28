#!/bin/sh
rm -rf rootfs
mkdir -p rootfs

for package in pickle-linux/main/*
do
    [[ "$(basename "$package")" = "base" ]] && continue
    cp -ra "$package/.build/filesystem/*" rootfs
done

cp -ra pickle-linux/main/base/.build/filesystem/* rootfs
mksquashfs rootfs rootfs.sqsh -comp lzo -force-uid 0 -force-gid 0
