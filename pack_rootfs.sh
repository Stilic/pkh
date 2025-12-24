#!/bin/sh
cd neld/.rootfs
rm -rf work
mkdir work
cd work

mkdir rootfs
cd rootfs

mkdir -p sys dev run proc var tmp usr root home etc

for package in ../../*.sqsh
do
    [[ $(basename "$package") = "base,1.sqsh" ]] && continue
    unsquashfs -f -d . "$package"
done

unsquashfs -f -d . ../../base,1.sqsh

if [ "$1" -eq 1 ]; then
    mkdir -p include/c++

    BASE="/usr/lib/"
    LIBS="libgmp ibasan libatomic libgcc_s libgomp libitm libquadmath libstdc++ libtsan libubsan libssp"

    cp -r /usr/include/c++/*/* include/c++
    cp ${BASE}gcc/*/*/* lib

    for lib in $LIBS; do
        find ${BASE} -maxdepth 1 \( -type f -o -type l \) -name "${lib}*" ! -name "*.la" -exec cp -P {} lib \;
    done

    cat <<EOF > include/execinfo.h
#ifndef _EXECINFO_H_
#define _EXECINFO_H_
#ifdef __cplusplus
extern "C" {
#endif

int     backtrace(void **, int);
char ** backtrace_symbols(void *const *, int);
void    backtrace_symbols_fd(void *const *, int, int);

#include <stddef.h>

int backtrace(void **buffer, int size) {
    (void)buffer;
    (void)size;
    return 0;
}

char **backtrace_symbols(void *const *buffer, int size) {
    (void)buffer;
    (void)size;
    return NULL;
}

void backtrace_symbols_fd(void *const *buffer, int size, int fd) {
    (void)buffer;
    (void)size;
    (void)fd;
}

#ifdef __cplusplus
}
#endif
#endif
EOF

    rm -rf *linux*
fi

if [ "$1" -eq 1 ] || [ "$1" -eq 2 ]; then
    # this is required since the host executables might be reliant on a libc in this location
    mkdir lib64
    ln -s ../lib/libc.so lib64/ld-linux-x86-64.so.2
fi

mksquashfs . ../rootfs.sqsh -comp lzo -force-uid 0 -force-gid 0
