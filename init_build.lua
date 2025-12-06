hostfs = true
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local tools = require "tools"
local config = require "neld.config"
local lfs = require "lfs"

local BASE = "neld/"
local ROOTFS_CACHE = BASE .. ".rootfs/"
local BUILD_CACHE = BASE .. ".bootstrap/"

-- TODO: variant support?
local function copy(package, path)
    os.execute("cp pickle-linux/" ..
        package .. "/.bootstrap/" .. tools.get_file(package, pkg(package).version) .. " " .. path)
end

os.execute("rm -rf " .. ROOTFS_CACHE)
lfs.mkdir(ROOTFS_CACHE)

for _, package in ipairs(config.bootstrap) do
    pkh.build(package)
    copy(package, ROOTFS_CACHE)
end

os.execute("./pack_rootfs.sh")

os.execute("rm -rf " .. BUILD_CACHE)
lfs.mkdir(BUILD_CACHE)
lfs.mkdir(BUILD_CACHE .. "work")

os.execute("cp " .. ROOTFS_CACHE .. "work/rootfs.sqsh " .. BUILD_CACHE .. "work")

for _, package in ipairs(config.development) do
    pkh.build(package)
    copy(package, BUILD_CACHE)
end

pkh.close()
