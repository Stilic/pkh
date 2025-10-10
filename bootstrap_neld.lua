require "global"
pcall(require, "luarocks.loader")

local lfs = require "lfs"
local llby = require "lullaby"
local repos = require "repos"
local config = require "neld.config"

lfs.mkdir("neld/.build")
lfs.chdir("neld/.build")

for _, package in ipairs(config.user_packages) do
    repos.download("user", package)
end

os.execute("rm -rf work")
lfs.mkdir("work")
lfs.chdir("work")

print("DOWNLOADING ROOTFS")
llby.net.srequest(config.repository .. "/rootfs.sqsh").content:file("rootfs.sqsh")

print("EXTRACTING KERNEL")
lfs.mkdir("linux")
repos.download("main", "linux", "linux")
lfs.link("linux/lib/modules/" .. repos.available_packages["linux"][1] .. "/vmlinuz", "vmlinuz", true)

print("CONFIGURING RAMDISK")
lfs.mkdir("ram_root")
repos.download("user", "busybox-static", "ram_root")
