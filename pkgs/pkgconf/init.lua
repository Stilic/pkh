local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "2.4.3"

self.sources = {
    { "source", "https://distfiles.ariadne.space/pkgconf/pkgconf-" .. self.version .. ".tar.xz" }
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
    os.execute("ln -sf pkgconf filesystem/usr/bin/pkg-config")
end

return self
