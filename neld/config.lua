local self = {
    repository = "pickle-linux",

    binhost = "https://pickle.stilic.fr",
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
        "curl",
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
        "bubblewrap",
        "lua",
    },
    sdk = {
        "nano",
        "cpio",
        "git",
    }
}

if stage ~= nil then
    if stage < 3 then
        table.insert(self.development, "llvm")
    end
    if stage ~= 1 then
        table.insert(self.development, "gcc")
    end
end

return self
