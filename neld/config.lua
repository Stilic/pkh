return {
    repository = "https://pickle.stilic.net/packages",
    layers = {
        main = {
            "linux",

            "musl",
            "musl-fts",
            "musl-obstack",
            "argp",
            "readline",
            "curses",

            "gperf",

            "libxml2",
            "libxslt",

            "sqlite3",

            "openssl",
            "libxcrypt",
            "toybox",
            "file",
            "diffutils",
            "gawk",
            "sed",
            "util-linux",

            "grep",

            "libmd",
            "dhcpcd",
            "ifupdown-ng",

            "bash",

            "xz",
            "zlib",
            "gettext",

            "unzip",
            "zip",
            "bzip2",

            "libcap",
            "udev",

            "linux-pam",
            "shadow",

            "dbus",
            "turnstile",

            "sysklogd",
            "dinit",

            -- TODO: package pkh itself
            "lzo",
            "squashfs-tools",
            "lua",
        },
        user = {
            -- TODO: move back to main repo
            "libunistring",
            "libidn2",
            "libpsl",
            "nghttp2",
            "zstd",
            "brotli",
            "curl",
            --

            "rsync",
            "cpio",
            "python",

            "pcre2",

            "flex",
            "binutils",
            "make",
            "pkgconf",
            "m4",
            "gcc",

            -- TODO: install dev dependencies
            "muon",
            "cmake",

            -- autotools
            "libtool",
            "automake",
            "autoconf",
            --

            -- "e2fsprogs",
            "libseccomp",
            "nano",

            "git",

            "luarocks",

            "cottonfetch"
        }
    }
}
