return {
    repository = "https://pickle.stilic.net/packages",
    layers = {
        main = {
            "linux",

            "musl",
            "musl-fts",
            "musl-obstack",
            "argp",

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

            -- for git
            "libxml2",

            -- TODO: package pkh itself
            "lzo",
            "squashfs-tools",
            "lua",
            "luarocks",
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

            "curses",
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

            -- autotools
            "libtool",
            "automake",
            "autoconf",
            --

            -- TODO: make these optional
            -- "e2fsprogs",
            -- "gperf",
            -- "libseccomp",
            "nano",

            "git",

            -- uwu
            "cottonfetch"
        }
    }
}
