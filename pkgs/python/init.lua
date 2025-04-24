local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "3.13.3"

self.sources = {
    { "source", "https://www.python.org/ftp/python/" .. self.version .. "/Python-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix=/usr --enable-shared --with-system-expat')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
