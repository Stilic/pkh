local config = require "neld.config"
local pkh = require "main"

for name, layer in pairs(config.layers) do
    for _, package in ipairs(layer) do
        pkh.build(name, package)
    end
end
