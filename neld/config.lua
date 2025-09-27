return {
    gnu_site = "https://mirror.cyberbits.eu/gnu",
    repository = "https://pickle.stilic.net/packages",
    layers = {
        main = {
            -- linux is kept inside the bootstrap script to be extracted
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

            -- for file
            "libseccomp",
            "zstd",

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

            "acl",
            "attr",
            "openpam",
            "shadow",

            "expat",
            "dbus",
            "turnstile",

            "e2fsprogs",
            "sysklogd",
            "dinit",

            -- TODO: package pkh itself
            "lzo",
            "squashfs-tools",
            "lua",
        },
        user = {
            "libunistring",
            "libidn2",
            "nghttp2",
            "curl",
            --

            "rsync",
            "cpio",
            "python",

            "pcre2",

            "binutils",
            "make",
            "pkgconf",
            "m4",
            "gcc",

            -- TODO: install dev dependencies
            "flex",
            "bison",
            "elfutils",
            "dosfstools",
            "meson",

            -- autotools
            "libtool",
            "automake",
            "autoconf",
            --

            "nano",

            "git",

            "luarocks",

            "cottonfetch",
        }
    }
}
