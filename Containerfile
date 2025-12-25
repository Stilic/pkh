FROM quay.io/stagex/pallet-gcc-gnu-busybox:sx2025.10.0 AS builder

COPY --from=quay.io/stagex/pallet-lua:sx2025.10.0 . /
COPY --from=quay.io/stagex/pallet-python:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-bash:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-samurai:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-meson:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-cmake:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-perl:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-make:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-ca-certificates:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-curl:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-openssl:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-git:sx2025.10.0 . /

# Bootstrap dependencies
COPY --from=quay.io/stagex/core-libzstd:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-libxml2:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-expat:sx2025.10.0 . /
COPY --from=quay.io/stagex/core-gmp:sx2025.10.0 . /
COPY --from=quay.io/stagex/user-mpfr:sx2025.10.0 . /
COPY --from=quay.io/stagex/user-elfutils:sx2025.10.0 . /

# PKH dependencies
COPY --from=quay.io/stagex/user-lzo:sx2025.10.0 . /
COPY --from=quay.io/stagex/user-fuse3:sx2025.10.0 . /
COPY --from=quay.io/stagex/user-fuse-overlayfs:sx2025.10.0 . /
COPY --from=quay.io/stagex/user-libcap:sx2025.10.0 . /

# Fix the ln command and C/C++ headers
COPY --from=quay.io/stagex/core-coreutils:sx2025.10.0 . /
RUN --network=none <<-EOF
cd /usr/bin
ln -s coreutils /tmp/ln
rm ln
mv /tmp/ln .
find /usr/include -type f -exec sed -i 's/#include_next/#include/g' {} +
EOF

FROM builder AS utils

ENV DESTDIR=/build

COPY --from=quay.io/stagex/core-luarocks:sx2025.10.0 . /

ADD https://gcc.gnu.org/pub/gcc/infrastructure/mpc-1.3.1.tar.gz /tmp/mpc.tar.gz
ADD https://gcc.gnu.org/pub/gcc/infrastructure/isl-0.24.tar.bz2 /tmp/isl.tar.bz2
ADD https://github.com/Stilic/lullaby/archive/refs/tags/1.0.0.tar.gz /tmp/lullaby.tar.gz
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
cd lullaby-1.0.0
make -j `nproc` CC=cc
make install INSTALL=/build/usr/local/lib/lua/
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

WORKDIR /pkh
ENTRYPOINT ["/bin/sh"]
