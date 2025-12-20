local self = {
    gnu_site = "https://mirror.cyberbits.eu/gnu",
    repository = "https://pickle.stilic.net",
    bootstrap = {
        "base",
        "linux",

        "gcc.libs",
        "musl",
        "musl-fts",
        "musl-obstack",

        "libiconv",
        "argp",
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
        "readline",
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
        "make",
        "pkgconf",
        "m4",
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

if stage ~= 1 then
    table.insert(self.development, "llvm")
end

if stage < 3 then
    table.insert(self.development, "gcc")
    table.insert(self.development, "cmake")
end

return self
