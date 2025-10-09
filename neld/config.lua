return {
    gnu_site = "https://mirror.cyberbits.eu/gnu",
    repository = "https://pickle.stilic.net",
    rootfs = {
        main = {
            "base",
            "linux",
            "musl",
            "musl-fts",
            "musl-obstack",
            "libiconv",
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

            "pcre2",
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
            "luafilesystem",
            "lullaby",
            "bubblewrap"
        },
        user = { "gcc.libs" }
    },
    user_packages = {
        "libunistring",
        "libidn2",
        "nghttp2",
        "curl",
        --

        "rsync",
        "cpio",
        "python",

        "binutils",
        "make",
        "pkgconf",
        "m4",
        "gcc",

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

        "cottonfetch",
    }
}
