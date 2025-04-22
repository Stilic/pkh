local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.65.0"

self.sources = {
    { "source", "https://github.com/nghttp2/nghttp2/releases/download/v" .. self.version .. "/nghttp2-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix=/usr')
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
