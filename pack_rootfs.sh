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

if [ "$1" -eq 1 ]; then
    BASE="/usr/lib/"
    LIBS="llibgmp ibasan libatomic libgcc_s libgomp libitm libquadmath libstdc++ libtsan libubsan libssp"

    cp -r /usr/include/c++ include
    cp -r -P ${BASE}gcc lib

    for lib in $LIBS; do
        find ${BASE} -maxdepth 1 \( -type f -o -type l \) -name "${lib}*" ! -name "*.la" -exec cp -P {} lib \;
    done
fi

mksquashfs . ../rootfs.sqsh -comp lzo -force-uid 0 -force-gid 0
