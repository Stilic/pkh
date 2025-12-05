buildmode = true
if arg[3] == "1" then
    hostfs = true
end
require "global"

local lfs = require "lfs"
local tools = require "tools"

local build_path = lfs.currentdir() .. "/pickle-linux/" .. arg[1] .. "/." .. (hostfs and "bootstrap" or "build")

local function pack(package, variant)
    lfs.chdir(build_path)

    -- create the filesystem
    local filesystem = "filesystem"
    if variant then
        filesystem = filesystem .. "-" .. variant.name
    end
    os.execute("rm -rf " .. filesystem)
    lfs.mkdir(filesystem)

    local ppack = variant
    if ppack then
        ppack = variant.pack
        if ppack then
            ppack()
        end
    else
        ppack = package.pack
        if ppack then
            ppack()
        end
    end

    lfs.chdir(build_path)

    -- remove libtool archives as they're useless
    os.execute("find " .. filesystem .. " -type f -name *.la -exec rm {} +")

    -- make the archive
    -- TODO: make the variant stuff more compact
    local vname = nil
    if variant then
        vname = variant.name
    end
    local file = tools.get_file(package.name, package.version, vname)
    os.remove(file)
    os.execute("mksquashfs " .. filesystem .. " " .. file .. " -comp lzo -force-uid 0 -force-gid 0")
end

local package = pkg(arg[1])

-- only build this if it wasn't done before
if arg[2] == "1" then
    local build = package.build
    if build then
        lfs.chdir(build_path)
        build()
    end

    pack(package)
end

if package.variants then
    for index, variant in pairs(package.variants) do
        variant.name = index

        local build = variant.build
        if build then
            lfs.chdir(build_path)
            build()
        end

        pack(package, variant)
    end
end
