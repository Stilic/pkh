require "luarocks.loader"
local lfs = require "lfs"
local pkh = require "main"

local function add(name)
    pkh.build(name, true)
    pkh.unpack("neld/root", name)
end

os.execute("rm -rf neld/root")
lfs.mkdir("neld/root")

add("linux")
add("musl")
add("busybox")

os.remove("neld/disk")
os.execute("truncate -s 1GB neld/disk")

os.execute("rm -rf neld/ram_root")
lfs.mkdir("neld/ram_root")

pkh.unpack("neld/ram_root", "busybox", "static")

os.remove("neld/vmlinuz")
os.execute("ln -s " ..
    lfs.currentdir() .. "/neld/root/usr/lib/modules/" .. require("pkgs.linux").version .. "/vmlinuz neld")
