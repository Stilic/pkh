local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "3.0"

self.sources = {
    { "source", "https://downloads.sourceforge.net/infozip/zip" .. self.version:gsub("%.", "") .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("make" .. system.get_make_jobs() .. ' -f unix/Makefile LOCAL_ZIP="-O2" prefix=/usr generic')
    os.execute('make -f unix/Makefile install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
