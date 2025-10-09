pcall(require, "luarocks.loader")
local lfs = require "lfs"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

function pkg(module)
    local name = module
    module = require("pickle-linux." .. module)
    if not module.name then
        local i, repository = name:match(".*%.()")
        if i ~= nil then
            repository = name:sub(1, i - 2)
            name = name:sub(i)
        end
        module.repository, module.name = repository, name
    end
    return module
end
