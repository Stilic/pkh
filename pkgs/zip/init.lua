local lfs = require "lfs"
local system = require "system"
local tools = require "tools"

local self = {}

self.version = "3.0"
self.sources = {
    { "source", "https://downloads.sourceforge.net/infozip/zip" .. self.version:gsub("%.", "") .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("make" .. system.get_make_jobs() .. ' -f unix/Makefile LOCAL_ZIP="' .. tools.DEFAULT_CFLAGS .. '" generic')
    os.execute('make -f unix/Makefile prefix="' .. lfs.currentdir() .. "/_install" .. '" install')
end

self.pack = tools.pack_default()

return self
