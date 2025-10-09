require "global"

local lfs = require "lfs"
local tools = require "tools"

local build_dir = "pickle-linux/" .. arg[1] .. "/" .. arg[2] .. "/.build"

local function pack(package, variant)
    lfs.chdir(build_dir)

    -- create the filesystem
    local filesystem = "filesystem"
    if variant then
        filesystem = filesystem .. "-" .. variant.name
    end
    os.execute("rm -rf " .. filesystem)
    lfs.mkdir(filesystem)

    print(lfs.currentdir)

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

local name = arg[1] .. "." .. arg[2]
local package = require("pickle-linux." .. name)
if not package.name then
    local i, repository = name:match(".*%.()")
    if i ~= nil then
        repository = name:sub(1, i - 2)
        name = name:sub(i)
    end
    package.repository, package.name = repository, name
end

if arg[3] == "1" then
    local build = package.build
    if build then
        lfs.chdir(build_dir)
        build()
    end
end
pack(package)

if package.variants then
    for index, variant in pairs(package.variants) do
        variant.name = index

        local build = variant.build
        if build then
            lfs.chdir(build_dir)
            build()
        end

        pack(package, variant)
    end
end
