stage = 4
require "global"
pcall(require, "luarocks.loader")

local config = require "neld.config"
local pkh = require "main"
pkh.init()

for _, package in ipairs(config.bootstrap) do
    pkh.build(package)
end
for _, package in ipairs(config.rootfs) do
    pkh.build(package)
end
for _, package in ipairs(config.development) do
    pkh.build(package)
end

pkh.close()
