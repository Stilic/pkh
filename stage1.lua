stage = 1
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local tools = require "tools"
local lfs = require "lfs"
local config = require "neld.config"

local BASE = "neld/"
local ROOTFS_CACHE = BASE .. ".rootfs/"
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
        package.name .. "/.stage1/" .. tools.get_file(name, package.version) .. " " .. path)

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

os.execute("rm -rf " .. ROOTFS_CACHE)
lfs.mkdir(ROOTFS_CACHE)

for _, package in ipairs(config.bootstrap) do
    build(package, ROOTFS_CACHE)
end

os.execute("./pack_rootfs.sh 1")

os.execute("rm -rf " .. BUILD_CACHE)
lfs.mkdir(BUILD_CACHE)
lfs.mkdir(BUILD_CACHE .. "work")

lfs.link("../../../" .. ROOTFS_CACHE .. "work/rootfs.sqsh", BUILD_CACHE .. "work/rootfs.sqsh", true)

for _, package in ipairs(config.development) do
    build(package, BUILD_CACHE)
end

pkh.close()
