hostfs = true
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local tools = require "tools"
local config = require "neld.config"
local lfs = require "lfs"

local BASE = "neld/"
local ROOTFS_CACHE = BASE .. ".rootfs/"
local BUILD_CACHE = BASE .. ".build/"

-- TODO: variant support?
local function build_and_copy(package)
    pkh.build(package)
    os.execute("cp pickle-linux/" ..
        package .. "/.build/" .. tools.get_file(package, pkg(package).version) .. " " .. ROOTFS_CACHE)
end

-- STAGE 1: distro toolchain bootstrap

os.execute("rm -rf " .. ROOTFS_CACHE)
lfs.mkdir(ROOTFS_CACHE)

for _, package in ipairs(config.development) do
    pkh.build(package)
end
for _, package in ipairs(config.bootstrap) do
    build_and_copy(package)
end

os.execute("./pack_rootfs.sh")

-- STAGE 2: development environment compilation

os.execute("rm -rf " .. BUILD_CACHE)
lfs.mkdir(BUILD_CACHE)
lfs.mkdir(BUILD_CACHE .. "work")

os.execute("cp " .. ROOTFS_CACHE .. "work/rootfs.sqsh " .. BUILD_CACHE .. "work")

pkh.close()
