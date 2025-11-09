FROM stagex/pallet-gcc-gnu-busybox

# Lua essentials
COPY --from=stagex/pallet-lua . /
COPY --from=stagex/core-luarocks . /
COPY --from=stagex/core-ca-certificates . /
COPY --from=stagex/core-curl . /
COPY --from=stagex/core-openssl . /

# Basis for PKH build
COPY --from=stagex/core-git . /
COPY --from=stagex/user-lzo . /
COPY --from=stagex/user-fuse-overlayfs . /

# Install LuaFileSystem
RUN ["luarocks", "install", "luafilesystem"]

# Install Lullaby
ADD https://github.com/Stilic/lullaby/archive/refs/tags/v0.0.2.tar.gz /tmp/lullaby.tar.gz
RUN --network=none <<-EOF
tar xf /tmp/lullaby.tar.gz
cd lullaby-0.0.2
make CC=gcc
make install
EOF

# Install Squashfs-tools
ADD https://github.com/plougher/squashfs-tools/releases/download/4.6.1/squashfs-tools-4.6.1.tar.gz /tmp/squashfs-tools.tar.gz
RUN --network=none <<-EOF
tar xf /tmp/squashfs-tools.tar.gz
cd squashfs-tools-4.6.1/squashfs-tools
make LZO_SUPPORT=1
make install
EOF

ENTRYPOINT ["/bin/sh"]
