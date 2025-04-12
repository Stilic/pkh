require "luarocks.loader"
local lfs = require "lfs"
local pkh = require "main"

local function add(name)
    if not lfs.attributes("pkgs/" .. name .. "/.build/" .. pkh.get_file(name, require("pkgs." .. name).version)) then
        pkh.build(name)
    end
    pkh.unpack("neld/root", name)
end

os.execute("rm -rf neld/root")
lfs.mkdir("neld/root")

add("linux")
add("musl")
add("busybox")
add("lua")
add("luarocks")

os.remove("neld/disk")
os.execute("truncate -s 1GB neld/disk")

os.execute("rm -rf neld/ram_root")
lfs.mkdir("neld/ram_root")

pkh.unpack("neld/ram_root", "busybox", "static")

os.remove("neld/vmlinuz")
os.execute("ln -s " ..
    lfs.currentdir() .. "/neld/root/usr/lib/modules/" .. require("pkgs.linux").version .. "/vmlinuz neld")
