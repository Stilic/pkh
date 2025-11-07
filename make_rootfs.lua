pcall(require, "luarocks.loader")

local lfs = require "lfs"
local repos = require "repos"
local config = require "neld.config"

lfs.mkdir("neld/.rootfs")
lfs.chdir("neld/.rootfs")

for layer, list in pairs(config.rootfs) do
    for _, package in ipairs(list) do
        repos.download(layer, package, nil, true)
    end
end
