require "global"
pcall(require, "luarocks.loader")

local lfs = require "lfs"
local pkh = require "main"

for file in lfs.dir("pickle-linux") do
    if file:sub(1, 1) ~= "." and lfs.attributes(file).mode == "directory" then
        pkh.build(file)
    end
end

pkh.close()
