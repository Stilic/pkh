require "global"
pcall(require, "luarocks.loader")

local lfs = require "lfs"
local pkh = require "main"

local repository = "pickle-linux/"
for file in lfs.dir(repository) do
    if file:sub(1, 1) ~= "." and lfs.attributes(repository .. file).mode == "directory" then
        pkh.build(file)
    end
end

pkh.close()
