require "luarocks.loader"
local lfs = require "lfs"

local self = {}

-- TODO: wrap sensible calls
function self.build(name)
    local package = require("pkgs." .. name)

    lfs.chdir("pkgs/" .. name)

    os.execute("rm -rf .build")
    lfs.mkdir(".build")
    lfs.chdir(".build")
    local build_path = lfs.currentdir()

    -- compile
    for _, source in ipairs(package.sources) do
        local path = source[1]
        os.execute("curl -o _" .. path .. " " .. source[2])
        lfs.mkdir(path)
        os.execute("tar -xf _" .. path .. " --strip-components=1 -C " .. path)
    end

    package.build()
    lfs.chdir(build_path)

    -- create the filesystem
    os.execute("rm -rf filesystem")
    lfs.mkdir("filesystem")
    print(lfs.currentdir())
    package.pack()
    lfs.chdir(build_path)

    -- make the archive
    local file = package.version .. ".sqsh"
    os.execute("rm -f " .. file)
    os.execute("mksquashfs filesystem " .. file .. " -comp lzo -force-uid 0 -force-gid 0")
end

function self.unpack(name, path)
    return os.execute("unsquashfs -d " ..
        path .. " -f pkgs/" .. name .. "/.build/" .. require("pkgs." .. name).version .. ".sqsh")
end

return self
