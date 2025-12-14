FROM stagex/pallet-gcc-gnu-busybox AS builder

COPY --from=stagex/pallet-lua . /
COPY --from=stagex/pallet-python . /
COPY --from=stagex/core-bash . /
COPY --from=stagex/core-samurai . /
COPY --from=stagex/core-meson . /
COPY --from=stagex/core-cmake . /
COPY --from=stagex/core-perl . /
COPY --from=stagex/core-make . /
COPY --from=stagex/core-ca-certificates . /
COPY --from=stagex/core-curl . /
COPY --from=stagex/core-openssl . /
COPY --from=stagex/core-git . /

# Bootstrap dependencies
COPY --from=stagex/core-libzstd . /
COPY --from=stagex/core-libxml2 . /
COPY --from=stagex/core-expat . /
COPY --from=stagex/core-gmp . /
COPY --from=stagex/user-mpfr . /
COPY --from=stagex/user-elfutils . /

# PKH dependencies
COPY --from=stagex/user-lzo . /
COPY --from=stagex/user-fuse3 . /
COPY --from=stagex/user-fuse-overlayfs . /
COPY --from=stagex/user-libcap . /

# Fix the ln command and C/C++ headers
COPY --from=stagex/core-coreutils . /
RUN --network=none <<-EOF
cd /usr/bin
ln -s coreutils /tmp/ln
rm ln
mv /tmp/ln .
find /usr/include -type f -exec sed -i 's/#include_next/#include/g' {} +
EOF

FROM builder AS utils

ENV DESTDIR=/build

COPY --from=stagex/core-luarocks . /

ADD https://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.3.1.tar.gz /tmp/mpc.tar.gz
ADD https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2 /tmp/isl.tar.bz2
ADD https://github.com/Stilic/lullaby/archive/refs/tags/v0.0.2.tar.gz /tmp/lullaby.tar.gz
ADD https://github.com/plougher/squashfs-tools/releases/download/4.6.1/squashfs-tools-4.6.1.tar.gz /tmp/squashfs-tools.tar.gz
ADD https://github.com/vasi/squashfuse/releases/download/0.6.1/squashfuse-0.6.1.tar.gz /tmp/squashfuse.tar.gz
ADD https://github.com/containers/bubblewrap/releases/download/v0.11.0/bubblewrap-0.11.0.tar.xz /tmp/bubblewrap.tar.xz

# Install MPC
RUN --network=none <<-EOF
set -eux
tar xf /tmp/mpc.tar.gz
cd mpc-1.3.1
./configure
make -j `nproc`
make install
EOF

# Install ISL
RUN --network=none <<-EOF
set -eux
tar xf /tmp/isl.tar.bz2
cd isl-0.24
./configure
make -j `nproc`
make install
EOF

# Install Lullaby
RUN --network=none <<-EOF
set -eux
tar xf /tmp/lullaby.tar.gz
cd lullaby-0.0.2
make -j `nproc` CC=cc
make install DESTDIR=/build/usr/local
EOF

# Install Squashfs-tools
RUN --network=none <<-EOF
set -eux
tar xf /tmp/squashfs-tools.tar.gz
cd squashfs-tools-4.6.1/squashfs-tools
make -j `nproc` LZO_SUPPORT=1
make install INSTALL_PREFIX=/build/usr/local
EOF

# Install Squashfuse
RUN --network=none <<-EOF
set -eux
tar xf /tmp/squashfuse.tar.gz
cd squashfuse-0.6.1
./configure
make -j `nproc`
make install
EOF

# Install Bubblewrap
RUN --network=none <<-EOF
set -eux
tar xf /tmp/bubblewrap.tar.xz
cd bubblewrap-0.11.0
meson setup -Dtests=false . output
meson compile -C output
meson install -C output
EOF

# Install LuaFileSystem
RUN <<-EOF
luarocks install --tree /build/usr/local luafilesystem 1.8.0-1
rm -rf /build/usr/local/lib/luarocks
EOF

FROM builder

COPY --from=utils /build .

# Provide a libexecinfo stub
RUN cat <<EOF > /usr/include/execinfo.h
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

WORKDIR /pkh
ENTRYPOINT ["/bin/sh"]
