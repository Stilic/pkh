stage = 4
require "global"
pcall(require, "luarocks.loader")

local lfs = require "lfs"
local repos = require "repos"
local config = require "neld.config"

lfs.mkdir("neld/.build")
lfs.chdir("neld/.build")

for _, package in ipairs(config.development) do
    repos.download(package)
end
for _, package in ipairs(config.production) do
    repos.download(package)
end

os.execute("rm -rf work")
lfs.mkdir("work")
lfs.chdir("work")

print("DOWNLOADING ROOTFS")
os.execute("curl -Lo rootfs.sqsh " .. config.binhost .. "/rootfs.sqsh")

print("EXTRACTING KERNEL")
lfs.mkdir("linux")
repos.download("linux", "linux")
lfs.link("linux/lib/modules/" .. repos.available_packages["linux"][1] .. "/vmlinuz", "vmlinuz", true)

print("CONFIGURING RAMDISK")
lfs.mkdir("ram_root")
repos.download("busybox-static", "ram_root")
