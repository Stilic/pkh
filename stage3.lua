stage = 3
require "global"
pcall(require, "luarocks.loader")

local config = require "neld.config"
local repos = require "repos"
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

pkh.close()

for _, package in ipairs(config.bootstrap) do
    repos.copy(package, repos.ROOTFS_CACHE)
end
for _, package in ipairs(config.development) do
    if package ~= "gcc" then
        repos.copy(package, repos.BUILD_CACHE)
    end
end

os.execute("./pack_rootfs.sh 2")
