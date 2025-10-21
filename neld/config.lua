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
            "awk",
            "util-linux",

            "pcre2",
            "grep",

            "libmd",
            "dhcpcd",
            "ifupdown-ng",

            "sh",

            "xz",
            "zlib",
            "libunistring",
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

            -- for gcc and gawk
            "gmp",
            "mpfr",
            "mpc",

            -- TODO: package pkh itself
            "lzo",
            "squashfs-tools",
            "lua",
            "luafilesystem",
            "lullaby",
            "libfuse",
            "fuse-overlayfs"
        },
        user = { "gcc.libs" }
    },
    -- final set of packages required to kickstart the process
    user_development = {
        "gcc",

        "binutils",
        "make",
        "pkgconf",
        "m4",
        -- "bison",
        "yacc",

        "libtool",
        "automake",
        "autoconf",

        -- for pkh sandbox
        "bubblewrap"
    },
    user_production = {
        "cottonfetch",
        "curl",
        "nano",

        "rsync",
        "cpio",
        "git",
    }
}
