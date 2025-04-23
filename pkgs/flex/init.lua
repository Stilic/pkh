local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "2.6.4"

self.sources = {
    { "source", "https://github.com/westes/flex/releases/download/v" .. self.version .. "/flex-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix=/usr')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
