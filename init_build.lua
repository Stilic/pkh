hostfs = true
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local config = require "neld.config"
local lfs = require "lfs"

local BASE = "neld/"
local ROOTFS_CACHE = BASE .. ".rootfs/"
local BUILD_CACHE = BASE .. ".build/"

-- TODO: variant support?
local function copy(name, path)
    local package = pkg(name)
    os.execute("cp pickle-linux/" ..
        package.name .. "/.bootstrap/*.sqsh " .. path)
end
local function build(package, path)
    pkh.build(package)

    if path then
        copy(package, path)

        package = pkg(package)
        if package.dependencies then
            for _, dep in ipairs(package.dependencies) do
                copy(dep.name, path)
            end
        end
    end
end

os.execute("rm -rf " .. ROOTFS_CACHE)
lfs.mkdir(ROOTFS_CACHE)

build("gcc", ROOTFS_CACHE)
for _, package in ipairs(config.bootstrap) do
    build(package, ROOTFS_CACHE)
end

os.execute("./pack_rootfs.sh")

os.execute("rm -rf " .. BUILD_CACHE)
lfs.mkdir(BUILD_CACHE)
lfs.mkdir(BUILD_CACHE .. "work")

os.execute("cp " .. ROOTFS_CACHE .. "work/rootfs.sqsh " .. BUILD_CACHE .. "work")

for _, package in ipairs(config.development) do
    if package ~= "gcc" then
        build(package, BUILD_CACHE)
    end
end

pkh.close()
