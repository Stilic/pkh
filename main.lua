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
function self.build(name)
    local compile, og_path, package = false, lfs.currentdir(), require("pkgs." .. name)
    package.name = name

    lfs.chdir("pkgs/" .. name)
    if not lfs.attributes(".build") then
        lfs.mkdir(".build")
        compile = true
    end
    lfs.chdir(".build")

    local build_path, pbuild = lfs.currentdir(), package.build
    if compile then
        for _, source in ipairs(package.sources) do
            local path = source[1]
            os.execute("curl -Lo _" .. path .. " " .. source[2])
            os.execute("rm -rf " .. path)
            lfs.mkdir(path)
            os.execute("tar xf _" .. path .. " --strip-components=1 -C " .. path)
        end

        if pbuild then
            pbuild()
            lfs.chdir(build_path)
        end
    end

    pack(package, build_path)

    if package.out then
        for index, variant in pairs(package.out) do
            variant.name = index

            if compile then
                if variant.build then
                    variant.build()
                elseif pbuild then
                    pbuild()
                end
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
