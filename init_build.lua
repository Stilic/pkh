hostfs = true
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local config = require "neld.config"

pkh.build("llvm")
for _, package in ipairs(config.bootstrap) do
    pkh.build(package)
end

pkh.close()
