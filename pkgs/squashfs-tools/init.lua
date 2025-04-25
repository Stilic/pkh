local lfs = require "lfs"
local system = require "system"
local tools = require "tools"

local self = {}

self.version = "4.6.1"
self.sources = {
    { "source", "https://github.com/plougher/squashfs-tools/archive/refs/tags/" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    local source_dir = lfs.currentdir()
    lfs.mkdir("_install")
    lfs.chdir("squashfs-tools")
    os.execute("make" .. system.get_make_jobs() .. " XATTR_SUPPORT=1 XZ_SUPPORT=1 LZO_SUPPORT=1 ZSTD_SUPPORT=1")
    os.execute('make install INSTALL_PREFIX="' .. source_dir .. '/_install/usr"')
end

self.pack = tools.pack_default()

return self
