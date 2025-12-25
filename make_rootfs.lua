pcall(require, "luarocks.loader")

local lfs = require "lfs"
local repos = require "repos"
local config = require "neld.config"

lfs.mkdir("neld/.rootfs")
lfs.chdir("neld/.rootfs")

for _, package in ipairs(config.rootfs) do
    print(package)
    repos.download(package)
end
