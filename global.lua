pcall(require, "luarocks.loader")
local lfs = require "lfs"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

local pkg_cache = {}

function pkg(module)
    local i, repository, name = module:match(".*%.()")
    if i ~= nil then
        repository = module:sub(1, i - 2)
        name = module:sub(i)
    end

    local package = pkg_cache[module]
    if package then
        return package
    end

    package = loadfile(current_directory .. "/pickle-linux/" .. repository .. "/" .. name .. ".lua", 't', {})
    pkg_cache[module] = package
    return package
end
