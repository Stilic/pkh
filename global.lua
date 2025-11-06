pcall(require, "luarocks.loader")
local lfs = require "lfs"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

local require_whitelist = {}
for _, module in ipairs({ "lfs", "system" }) do
    require_whitelist[module] = module
end
local function secure_require(module)
    if module == "tools" or module == "neld.config" then
        return require(module)
        ---@diagnostic disable-next-line: undefined-global
    elseif buildmode then
        if require_whitelist[module] then
            return require(module)
        end
        error("blacklisted module: " .. module)
    end
    return nil
end

local package_cache = {}
local package_environment = {}

function pkg(module)
    local i, repository, name = module:match(".*%.()")
    if i ~= nil then
        repository = module:sub(1, i - 2)
        name = module:sub(i)
    end

    local package = package_cache[module]
    if package then
        return package
    end

    package = { repository = repository, name = name }
    loadfile(current_directory .. "/pickle-linux/" .. repository .. "/" .. name .. "/init.lua", "t",
        setmetatable(package, { __index = package_environment }))()
    package_cache[module] = package
    return package
end

---@diagnostic disable-next-line: undefined-global
if buildmode then
    package_environment.os = os
end
package_environment.require = secure_require
package_environment.pkg = pkg
