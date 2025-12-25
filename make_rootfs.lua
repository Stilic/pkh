stage = 4
require "global"
pcall(require, "luarocks.loader")

local lfs = require "lfs"
local repos = require "repos"
local config = require "neld.config"

repos.fetch()

lfs.mkdir("neld/.rootfs")
lfs.chdir("neld/.rootfs")

for _, package in ipairs(config.bootstrap) do
    repos.download(package)
end
for _, package in ipairs(config.rootfs) do
    repos.download(package)
end
