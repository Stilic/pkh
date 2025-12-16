stage = 1
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
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

pkh.close()
