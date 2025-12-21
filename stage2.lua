stage = 2
require "global"
pcall(require, "luarocks.loader")

local tools = require "tools"
local config = require "neld.config"
local pkh = require "main"
pkh.init()

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

    if copied_packages[name] then
        return
    else
        copied_packages[name] = true
    end

    os.execute("cp pickle-linux/" ..
        package.name .. "/.stage2/" .. tools.get_file(name, package.version) .. " " .. path)

    if package.dependencies then
        for _, dep in ipairs(package.dependencies) do
            copy(dep.name, path)
        end
    end
end

pkh.build("gcc")

copy("gcc.libs", ROOTFS_CACHE)
copy("gcc", BUILD_CACHE)

os.execute("./pack_rootfs.sh 2")

pkh.close()

--------------------------------

pkh.init()

for _, package in ipairs(config.development) do
    if package ~= "gcc" then
        pkh.build(package)
        copy(package, BUILD_CACHE)
    end
end

for _, package in ipairs(config.bootstrap) do
    pkh.build(package)
    copy(package, ROOTFS_CACHE)
end

os.execute("./pack_rootfs.sh 2")

pkh.close()
