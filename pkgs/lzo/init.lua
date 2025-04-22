local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "2.10"

self.sources = {
    { "source", "https://www.oberhumer.com/opensource/lzo/download/lzo-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("./configure --prefix=/usr --enable-shared")
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
