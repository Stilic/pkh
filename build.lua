require "global"
pcall(require, "luarocks.loader")

local lfs = require "lfs"
local pkh = require "main"

for package in lfs.dir("pickle-linux") do
    if package ~= "." and package ~= ".." then
        pkh.build(package)
    end
end

pkh.close()
