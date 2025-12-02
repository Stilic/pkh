FROM stagex/pallet-gcc-gnu-busybox

COPY --from=stagex/pallet-lua . /
COPY --from=stagex/pallet-python . /
COPY --from=stagex/core-samurai . /
COPY --from=stagex/core-meson . /
COPY --from=stagex/core-cmake . /
COPY --from=stagex/core-perl . /
COPY --from=stagex/core-make . /
COPY --from=stagex/core-luarocks . /
COPY --from=stagex/core-ca-certificates . /
COPY --from=stagex/core-curl . /
COPY --from=stagex/core-openssl . /
COPY --from=stagex/core-git . /

# For Pickle's Python
COPY --from=stagex/core-expat . /

# PKH dependencies
COPY --from=stagex/user-patch . /
COPY --from=stagex/user-lzo . /
COPY --from=stagex/user-fuse3 . /
COPY --from=stagex/user-fuse-overlayfs . /
COPY --from=stagex/user-libcap . /

RUN <<-EOF
find /usr/include -type f -exec sed -i 's/#include_next/#include/g' {} +
EOF

# Install Lullaby
ADD https://github.com/Stilic/lullaby/archive/refs/tags/v0.0.2.tar.gz /tmp/lullaby.tar.gz
RUN --network=none <<-EOF
set -eux
tar xf /tmp/lullaby.tar.gz
cd lullaby-0.0.2
make CC=cc
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

# Provide a libexecinfo stub
# RUN cat <<EOF > /usr/include/execinfo.h
# #ifndef _EXECINFO_H_
# #define _EXECINFO_H_
# #ifdef __cplusplus
# extern "C" {
# #endif

# int     backtrace(void **, int);
# char ** backtrace_symbols(void *const *, int);
# void    backtrace_symbols_fd(void *const *, int, int);

# #include <stddef.h>

# int backtrace(void **buffer, int size) {
#     (void)buffer;
#     (void)size;
#     return 0;
# }

# char **backtrace_symbols(void *const *buffer, int size) {
#     (void)buffer;
#     (void)size;
#     return NULL;
# }

# void backtrace_symbols_fd(void *const *buffer, int size, int fd) {
#     (void)buffer;
#     (void)size;
#     (void)fd;
# }

# #ifdef __cplusplus
# }
# #endif
# #endif
# EOF

# Install LuaFileSystem
RUN ["luarocks", "install", "luafilesystem"]

WORKDIR /pkh
ENTRYPOINT ["/bin/sh"]
