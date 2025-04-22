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
add("busybox")

add("gmp")
add("mpfr")
add("mpc")
add("binutils")
add("gcc")

add("make")

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
add("git")

-- package manager
add("lzo")
add("squashfs-tools")
add("lua")
add("luarocks")

os.execute("rm -rf neld/ram_root")
lfs.mkdir("neld/ram_root")

pkh.unpack("neld/ram_root", "busybox", "static")

os.remove("neld/vmlinuz")
os.execute("ln -s root/lib/modules/" .. require("pkgs.linux").version .. "/vmlinuz neld")
