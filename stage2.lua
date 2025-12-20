stage = 2
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local tools = require "tools"

local BASE = "neld/"
local ROOTFS_CACHE = BASE .. ".rootfs/"
local BUILD_CACHE = BASE .. ".build/"

local copied_packages = {}
local function copy(name, path)
    local package

    local i = name:find("%.")
    if i then
        package = pkg(name:sub(1, i - 1))
    else
        package = pkg(name)
    end

    if copied_packages[package.name] then
        return
    else
        copied_packages[package.name] = true
    end

    os.execute("cp pickle-linux/" ..
        package.name .. "/.stage2/" .. tools.get_file(name, package.version) .. " " .. path)

    if package.dependencies then
        for _, dep in ipairs(package.dependencies) do
            copy(dep.name, path)
        end
    end
end

pkh.build("gcc-libs")
pkh.build("llvm")

copy("gcc-libs", ROOTFS_CACHE)
copy("llvm", BUILD_CACHE)

os.execute("./pack_rootfs.sh 2")

pkh.close()
