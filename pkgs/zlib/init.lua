local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.3.1"

self.sources = {
    { "source", "https://zlib.net/zlib-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("./configure --prefix=/usr")
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
