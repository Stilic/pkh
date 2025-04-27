require "luarocks.loader"
local lfs = require "lfs"
local pkh = require "main"
local system = require "system"

local BINARY_HOST = "https://pickle.stilic.net/packages"

local function compile(name)
    pkh.build(name)
    pkh.unpack("neld/root", name)
end

local function download(name)

end

local base_overlay = {
    -- base
    "linux",

    "musl",
    "musl-fts",
    "musl-obstack",
    "argp",
    "readline",
    "curses",

    -- rsync deps
    "attr",
    "acl",
    "popt",
    --

    -- util-linux deps
    "sqlite3",
    --

    "toybox",
    "file",
    "rsync",
    "diffutils",
    "gawk",
    "sed",
    "cpio",
    "e2fsprogs",
    "util-linux",
    "perl",
    "python",

    "pcre2",
    "grep",

    -- nano
    "gperf",
    "libseccomp",
    "nano",

    "libmd",
    "dhcpcd",
    "ifupdown-ng",

    "libxcrypt",
    "bash",

    "xz",

    "gmp",
    "mpfr",
    "mpc",
    "binutils",
    "gcc",

    -- autotools
    "libtool",
    "automake",
    "autoconf",
    --

    "make",
    "pkgconf",

    "cmake",

    -- curl
    "libunistring",
    "libidn2",
    "libpsl",
    "openssl",
    "nghttp2",
    "zlib",
    "zstd",
    "brotli",
    "curl",

    -- git
    "expat",
    "libiconv",
    "libxml2",
    "git",

    "gettext",
    "m4",

    -- linux build dependencies
    "bzip2",
    "flex",
    "bison",
    "elfutils",
    "dosfstools",

    -- package manager
    "unzip",
    "zip",
    "lzo",
    "squashfs-tools",
    "lua",
    "luarocks",
}

-- os.execute("rm -rf neld/root")
-- lfs.mkdir("neld/root")

-- build from source
-- for _, pkg in ipairs(base_overlay) do
--     compile(pkg)
-- end

-- build from binhost
local og_path = lfs.currentdir()

os.execute("rm -rf neld/.cache")
lfs.mkdir("neld/.cache")
lfs.chdir("neld/.cache")

local available_packages = system.capture("curl -L " .. BINARY_HOST .. "/available.txt")

-- for _, pkg in ipairs(base_overlay) do
--     download(pkg)
-- end

-- lfs.chdir(og_path)
--

-- os.execute("rm -rf neld/ram_root")
-- lfs.mkdir("neld/ram_root")

-- pkh.build("busybox-static")
-- pkh.unpack("neld/ram_root", "busybox-static")

-- os.remove("neld/vmlinuz")
-- os.execute("ln -s root/lib/modules/" .. require("pkgs.linux").version .. "/vmlinuz neld")
