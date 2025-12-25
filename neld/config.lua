local self = {
    repository = "pickle-linux",

    binhost = "https://pickle.stilic.net",
    gnu_site = "https://mirror.cyberbits.eu/gnu",

    bootstrap = {
        "base",
        "linux",

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

        "lua",

        -- TODO: remove this once we figured out how to add it to stage4
        "gmp"
    },
    rootfs = {
        "gcc.libs",
        "readline",
        "libmd",
        "dhcpcd",
        "ifupdown-ng",

        "unzip",
        "zip",

        "udev",

        "shadow",

        "dbus",
        "turnstile",

        "e2fsprogs",
        "sysklogd",
        "dinit",

        -- TODO: package pkh itself
        "lullaby",
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

if stage < 3 then
    table.insert(self.development, "llvm")
end
if stage ~= 1 then
    table.insert(self.development, "gcc")
end

return self
