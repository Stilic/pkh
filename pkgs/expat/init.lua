local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "2.7.1"

self.sources = {
    { "source", "https://github.com/libexpat/libexpat/releases/download/R_" .. self.version:gsub("%.", "_") .. "/expat-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" CPPFLAGS=-DXML_LARGE_SIZE --prefix=/usr')
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
