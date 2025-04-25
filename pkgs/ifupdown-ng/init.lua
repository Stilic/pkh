local lfs = require "lfs"
local system = require "system"
local tools = require "tools"

local self = {}

self.version = "0.12.1"
self.sources = {
    { "source", "https://github.com/ifupdown-ng/ifupdown-ng/archive/refs/tags/ifupdown-ng-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("make" .. system.get_make_jobs() .. tools.get_flags())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

self.pack = tools.pack_default()

return self
