FROM stagex/pallet-gcc-meson-busybox

COPY --from=stagex/pallet-lua . /
COPY --from=stagex/core-make . /
COPY --from=stagex/core-luarocks . /
COPY --from=stagex/core-ca-certificates . /
COPY --from=stagex/core-curl . /
COPY --from=stagex/core-openssl . /
COPY --from=stagex/core-git . /

# PKH dependencies
COPY --from=stagex/user-patch . /
COPY --from=stagex/user-lzo . /
COPY --from=stagex/user-fuse3 . /
COPY --from=stagex/user-fuse-overlayfs . /
COPY --from=stagex/user-libcap . /

# Bootstrap dependencies
COPY --from=stagex/core-gmp . /
COPY --from=stagex/user-mpfr . /

# Install MPC
ADD https://ftp.gnu.org/gnu/mpc/mpc-1.3.1.tar.gz /tmp/mpc.tar.gz
RUN --network=none <<-EOF
set -eux
tar xf /tmp/mpc.tar.gz
cd mpc-1.3.1
./configure
make
make install
EOF

# Install Lullaby
ADD https://github.com/Stilic/lullaby/archive/refs/tags/v0.0.2.tar.gz /tmp/lullaby.tar.gz
RUN --network=none <<-EOF
set -eux
tar xf /tmp/lullaby.tar.gz
cd lullaby-0.0.2
make CC=gcc
make install
EOF

# Install Squashfs-tools
ADD https://github.com/plougher/squashfs-tools/releases/download/4.6.1/squashfs-tools-4.6.1.tar.gz /tmp/squashfs-tools.tar.gz
RUN --network=none <<-EOF
set -eux
tar xf /tmp/squashfs-tools.tar.gz
cd squashfs-tools-4.6.1/squashfs-tools
make LZO_SUPPORT=1
make install
EOF

# Install Squashfuse
ADD https://github.com/vasi/squashfuse/releases/download/0.6.1/squashfuse-0.6.1.tar.gz /tmp/squashfuse.tar.gz
RUN --network=none <<-EOF
set -eux
tar xf /tmp/squashfuse.tar.gz
cd squashfuse-0.6.1
./configure
make
make install
EOF

# Install Bubblewrap
ADD https://github.com/containers/bubblewrap/releases/download/v0.11.0/bubblewrap-0.11.0.tar.xz /tmp/bubblewrap.tar.xz
RUN --network=none <<-EOF
set -eux
tar xf /tmp/bubblewrap.tar.xz
cd bubblewrap-0.11.0
meson setup -Dtests=false . output
meson compile -C output
meson install -C output
EOF

# Install LuaFileSystem
RUN ["luarocks", "install", "luafilesystem"]

ENTRYPOINT ["/bin/sh"]
