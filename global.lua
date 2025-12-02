pcall(require, "luarocks.loader")
local lfs = require "lfs"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

local function secure_require(module)
    if module == "tools" or module == "neld.config" then
        return require(module)
        ---@diagnostic disable-next-line: undefined-global
    elseif buildmode then
        if module == "lfs" or module == "system" then
            return require(module)
        end
        error("blacklisted module: " .. module)
    end
    return nil
end

local package_cache = {}
local package_environment = {
    require = secure_require,
    string = setmetatable({}, {
        __index = function(_, key)
            if key == "dump" then
                return nil
            end
            return string[key]
        end,
        __newindex = function()
            error("attempt to modify read-only table 'string'")
        end,
    }),
    math = math,
    table = table,
    print = print,
    pairs = pairs,
    ipairs = ipairs,
    type = type,
    error = error,
    tostring = tostring,
    tonumber = tonumber,
}

function pkg(name)
    local package = package_cache[name]
    if package then
        return package
    end

    package = { name = name }
    loadfile(current_directory .. "/pickle-linux/" .. name .. "/init.lua", "t",
        setmetatable(package, { __index = package_environment }))()
    package_cache[name] = package
    return package
end

---@diagnostic disable-next-line: undefined-global
package_environment.hostfs = hostfs
package_environment.buildmode = buildmode
if buildmode then
    package_environment.os = os
end
package_environment.pkg = pkg
