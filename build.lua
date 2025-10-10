pcall(require, "luarocks.loader")
local lfs = require "lfs"
local pkh = require "main"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

pkh.init()

local repos = "pickle-linux"
for layer in lfs.dir(repos) do
    if layer ~= "." and layer ~= ".." then
        local layer_path = repos .. "/" .. layer
        local attr = lfs.attributes(layer_path)
        if attr.mode == "directory" then
            for package in lfs.dir(layer_path) do
                if package ~= "." and package ~= ".." then
                    pkh.build(layer, package)
                end
            end
        end
    end
end

pkh.close()
