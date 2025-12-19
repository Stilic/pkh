stage = 2
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local tools = require "tools"

local BASE = "neld/"
local BUILD_CACHE = BASE .. ".build/"

local built_packages = {}
local function copy(name, path)
    local package

    local i = name:find("%.")
    if i then
        package = pkg(name:sub(1, i - 1))
    else
        package = pkg(name)
    end

    os.execute("cp pickle-linux/" ..
        package.name .. "/.stage2/" .. tools.get_file(name, package.version) .. " " .. path)

    return package
end
local function build(package, path)
    if built_packages[package] then
        return
    else
        built_packages[package] = true
    end

    pkh.build(package)

    if path then
        package = copy(package, path)
        if package.dependencies then
            for _, dep in ipairs(package.dependencies) do
                copy(dep.name, path)
            end
        end
    end
end

build("gcc", BUILD_CACHE)

os.execute("./pack_rootfs.sh 0")

pkh.close()
