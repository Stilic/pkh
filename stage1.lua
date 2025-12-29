stage = 1
require "global"
pcall(require, "luarocks.loader")

local lfs = require "lfs"
local config = require "neld.config"
local pkh = require "main"
local repos = require "repos"

os.execute("rm -rf " .. repos.BUILD_CACHE)
lfs.mkdir(repos.BUILD_CACHE)
lfs.mkdir(repos.BUILD_CACHE .. "work")

lfs.link("../../.rootfs/work/rootfs.sqsh", repos.BUILD_CACHE .. "work/rootfs.sqsh", true)

os.execute("rm -rf " .. repos.ROOTFS_CACHE)
lfs.mkdir(repos.ROOTFS_CACHE)

for _, package in ipairs(config.development) do
    pkh.build(package)
    repos.copy(package, repos.BUILD_CACHE)
end

for _, package in ipairs(config.bootstrap) do
    pkh.build(package)
    repos.copy(package, repos.ROOTFS_CACHE)
end

pkh.close()

os.execute("./pack_rootfs.sh 1")
