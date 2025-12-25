stage = 5
require "global"
pcall(require, "luarocks.loader")

local config = require "neld.config"
local pkh = require "main"

for _, package in ipairs(config.sdk) do
    pkh.build(package)
end

pkh.close()
