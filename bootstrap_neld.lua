require "luarocks.loader"
local lfs = require "lfs"
local pkh = require "main"

local function add(name)
    pkh.build(name)
    pkh.unpack("neld/root", name)
end

os.execute("rm -rf neld/root")
lfs.mkdir("neld/root")

-- base
add("linux")

add("musl")
add("musl-fts")
add("musl-obstack")
add("argp")
add("readline")
add("curses")

-- rsync deps
add("attr")
add("acl")
add("popt")
--

-- util-linux deps
add("sqlite3")
--

add("toybox")
add("file")
add("rsync")
add("diffutils")
add("gawk")
add("sed")
add("cpio")
add("e2fsprogs")
add("util-linux")
add("perl")
add("python")

-- nano
add("gperf")
add("libseccomp")
add("nano")

add("libmd")
add("dhcpcd")
add("ifupdown-ng")

add("libxcrypt")
add("bash")

add("xz")

add("gmp")
add("mpfr")
add("mpc")
add("binutils")
add("gcc")

-- autotools
add("libtool")
add("automake")
add("autoconf")
--

add("make")
add("pkgconf")

add("cmake")

-- curl
add("libunistring")
add("libidn2")
add("libpsl")
add("openssl")
add("nghttp2")
add("zlib")
add("zstd")
add("brotli")
add("curl")

-- git
add("expat")
add("libiconv")
add("libxml2")
add("git")

add("gettext")
add("m4")

-- linux build dependencies
add("bzip2")
add("flex")
add("bison")
add("elfutils")
add("dosfstools")

-- package manager
add("unzip")
add("zip")
add("lzo")
add("squashfs-tools")
add("lua")
add("luarocks")

os.execute("rm -rf neld/ram_root")
lfs.mkdir("neld/ram_root")

pkh.build("busybox-static")
pkh.unpack("neld/ram_root", "busybox-static")

os.remove("neld/vmlinuz")
os.execute("ln -s root/lib/modules/" .. require("pkgs.linux").version .. "/vmlinuz neld")
