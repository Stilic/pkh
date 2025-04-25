local lfs = require "lfs"
local system = require "system"
local tools = require "tools"

local self = {}

self.version = "0.8.12"
self.sources = {
    { "source", "https://landley.net/toybox/downloads/toybox-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("cp ../../config .config")
    os.execute('KCONFIG_NOTIMESTAMP=1 CFLAGS="-O2" make' .. system.get_make_jobs())
    os.execute("make install")
end

self.pack = tools.pack_default()

return self
