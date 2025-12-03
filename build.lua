require "global"
pcall(require, "luarocks.loader")

local lfs = require "lfs"
local pkh = require "main"

local repository = "pickle-linux/"
for package in lfs.dir(repository) do
    if package:sub(1, 1) ~= "." and lfs.attributes(repository .. package).mode == "directory" then
        pkh.build(package)
    end
end

pkh.close()
