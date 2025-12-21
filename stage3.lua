stage = 3
require "global"
pcall(require, "luarocks.loader")

local config = require "neld.config"
local stageutils = require "stageutils"
local pkh = require "main"
pkh.init()

for _, package in ipairs(config.bootstrap) do
    pkh.build(package)
    stageutils.copy(package, stageutils.ROOTFS_CACHE)
end

for _, package in ipairs(config.development) do
    if package ~= "gcc" then
        pkh.build(package)
        stageutils.copy(package, stageutils.BUILD_CACHE)
    end
end

os.execute("./pack_rootfs.sh 2")

pkh.close()
