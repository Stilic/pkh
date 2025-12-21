stage = 3
require "global"
pcall(require, "luarocks.loader")

local config = require "neld.config"
local stageutils = require "stageutils"
local pkh = require "main"

for _, package in ipairs(config.bootstrap) do
    pkh.build(package)
end
for _, package in ipairs(config.development) do
    -- skip building the compiler since it hardly impacts the process
    if package ~= "gcc" then
        pkh.build(package)
    end
end

for _, package in ipairs(config.bootstrap) do
    stageutils.copy(package, stageutils.ROOTFS_CACHE)
end
for _, package in ipairs(config.development) do
    if package ~= "gcc" then
        stageutils.copy(package, stageutils.BUILD_CACHE)
    end
end

os.execute("./pack_rootfs.sh 2")

pkh.close()
