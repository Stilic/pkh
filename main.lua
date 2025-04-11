require "luarocks.loader"
local lfs = require "lfs"

local self = {}

function self.get_file(name, version, variant)
    local file = name
    if variant then
        file = file .. "-" .. variant
    end
    return file .. "," .. version .. ".sqsh"
end

local function pack(package, build_path, variant)
    -- create the filesystem
    os.execute("rm -rf filesystem")
    lfs.mkdir("filesystem")

    local ppack = variant
    if ppack then
        ppack = variant.pack
        if ppack then
            ppack()
        end
    end
    if not ppack then
        ppack = package.pack
        if ppack then
            ppack()
        end
    end
    lfs.chdir(build_path)

    -- make the archive
    -- TODO: make the variant stuff more compact
    local vname = nil
    if variant then
        vname = variant.name
    end
    local file = self.get_file(package.name, package.version, vname)
    os.remove(file)
    os.execute("mksquashfs filesystem " .. file .. " -comp lzo -force-uid 0 -force-gid 0")
end
function self.build(name, keep_build)
    local og_path, package = lfs.currentdir(), require("pkgs." .. name)
    package.name = name

    lfs.chdir("pkgs/" .. name)
    if not lfs.attributes(".build") then
        keep_build = false
    end

    if not keep_build then
        os.execute("rm -rf .build")
        lfs.mkdir(".build")
    end
    lfs.chdir(".build")
    local build_path = lfs.currentdir()

    -- compile
    if not keep_build then
        for _, source in ipairs(package.sources) do
            local path = source[1]
            os.execute("curl -o _" .. path .. " " .. source[2])
            lfs.mkdir(path)
            os.execute("tar -xf _" .. path .. " --strip-components=1 -C " .. path)
        end
    end

    -- main
    local pbuild = package.build
    if pbuild then
        pbuild()
        lfs.chdir(build_path)
    end
    pack(package, build_path)

    -- variants
    if package.out then
        for index, variant in pairs(package.out) do
            variant.name = index
            if variant.build then
                variant.build()
            elseif pbuild then
                pbuild()
            end
            lfs.chdir(build_path)
            pack(package, build_path, variant)
        end
    end

    lfs.chdir(og_path)
end

function self.unpack(path, name, variant)
    return os.execute("unsquashfs -d " ..
        path .. " -f pkgs/" .. name .. "/.build/" .. self.get_file(name, require("pkgs." .. name).version, variant))
end

return self
