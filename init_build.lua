hostfs = true
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"
local tools = require "tools"
local config = require "neld.config"
local lfs = require "lfs"

local BASE = "neld/"
local ROOTFS_CACHE = BASE .. ".rootfs/"
local BUILD_CACHE = BASE .. ".bootstrap/"

-- TODO: variant support?
local function copy(name, path)
    local package = pkg(name)
    os.execute("cp pickle-linux/" ..
        package.name .. "/.bootstrap/" .. tools.get_file(package.name, package.version) .. " " .. path)
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

for _, package in ipairs(config.bootstrap) do
    build(package, ROOTFS_CACHE)
end

print("MAKING ROOTFS")
os.execute("./pack_rootfs.sh")

os.execute("rm -rf " .. BUILD_CACHE)
lfs.mkdir(BUILD_CACHE)
lfs.mkdir(BUILD_CACHE .. "work")

os.execute("cp " .. ROOTFS_CACHE .. "work/rootfs.sqsh " .. BUILD_CACHE .. "work")

for _, package in ipairs(config.development) do
    build(package, BUILD_CACHE)
end

local function extract(package, directory)
    package = pkg(package)
    pkh.build(package.name)
    os.execute("unsquashfs -d " ..
        BUILD_CACHE .. "work/" .. directory .. " -f " .. tools.get_file(package.name, package.version))
end

print("COMPILING KERNEL")
extract("linux", "linux")
print(lfs.link("linux/lib/modules/" .. pkg("linux").version .. "/vmlinuz", ROOTFS_CACHE .. "work/vmlinuz", true))

print("CONFIGURING RAMDISK")
extract("busybox-static", "ram_root")

pkh.close()
