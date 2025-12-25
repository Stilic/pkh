stage = 4
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local repos = require "repos"

local lfs = require "lfs"
local config = require "neld.config"

for _, package in ipairs(config.bootstrap) do
    pkh.build(package)
end
for _, package in ipairs(config.rootfs) do
    pkh.build(package)
end
for _, package in ipairs(config.development) do
    pkh.build(package)
end
for _, package in ipairs(config.sdk) do
    pkh.build(package)
end
pkh.build("busybox-static")

pkh.close()

os.execute("rm -rf " .. repos.ROOTFS_CACHE)
lfs.mkdir(repos.ROOTFS_CACHE)

os.execute("rm -f " .. repos.BUILD_CACHE .. "*.sqsh")

for _, package in ipairs(config.bootstrap) do
    repos.copy(package, repos.ROOTFS_CACHE)
end
for _, package in ipairs(config.rootfs) do
    repos.copy(package, repos.ROOTFS_CACHE)
end
for _, package in ipairs(config.development) do
    repos.copy(package, repos.BUILD_CACHE)
end
for _, package in ipairs(config.sdk) do
    repos.copy(package, repos.BUILD_CACHE)
end

os.execute("./pack_rootfs.sh")

print("EXTRACTING KERNEL")
repos.extract(repos.BUILD_CACHE .. "work/linux", "linux")
os.remove(repos.BUILD_CACHE .. "work/vmlinuz")
lfs.link("linux/lib/modules/" .. pkg("linux").version .. "/vmlinuz",
    repos.BUILD_CACHE .. "work/vmlinuz",
    true)

print("CONFIGURING RAMDISK")
lfs.mkdir("ram_root")
repos.extract(repos.BUILD_CACHE .. "work/ram_root", "busybox-static")
