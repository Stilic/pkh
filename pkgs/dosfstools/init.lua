local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "4.2"

self.sources = {
    { "source", "https://github.com/dosfstools/dosfstools/releases/download/v" .. self.version .. "/dosfstools-" .. self.version .. ".tar.gz" }
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
