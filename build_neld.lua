local lfs = require "lfs"
local pkh = require "main"
local config = require "neld.config"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

for name, layer in pairs(config.layers) do
    for _, package in ipairs(layer) do
        pkh.build(name, package)
    end
end
