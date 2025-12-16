local self = {
    gnu_site = "https://mirror.cyberbits.eu/gnu",
    repository = "https://pickle.stilic.net",
    bootstrap = {
        "linux",
        "base",

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
        "openssl",
        "libxcrypt",
        "pcre2",
        "zlib",
        "libunistring",
        "gettext",
        "expat",

        "sh",
        "toybox",
        "awk",
        "grep",
        "file",
        "diffutils",
        "util-linux",
        "xz",

        "lua"
    },
    rootfs = {
        "gcc.libs",

        "libmd",
        "dhcpcd",
        "ifupdown-ng",

        "unzip",
        "zip",
        "bzip2",

        "libcap",
        "udev",

        "acl",
        "attr",
        "openpam",
        "shadow",

        "dbus",
        "turnstile",

        "e2fsprogs",
        "sysklogd",
        "dinit",

        -- TODO: package pkh itself
        "lullaby",
        "libfuse",
        "squashfuse",
        "fuse-overlayfs",
    },
    -- final set of packages required to kickstart the process
    development = {
        "binutils",
        "make",
        "pkgconf",
        "m4",
        -- "bison",
        "yacc",

        "libtool",
        "automake",
        "autoconf",

        -- for pkh
        "luafilesystem",
        "squashfs-tools",
        "bubblewrap"
    },
    production = {
        "cottonfetch",
        "curl",
        "nano",

        "rsync",
        "cpio",
        "git",
    }
}

if stage < 2 then
    table.insert(self.development, "gcc-bootstrap")
    table.insert(self.development, "gcc-bootstrap.libs")
else
    table.insert(self.development, "gcc")
end

return self
