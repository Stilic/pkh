local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "4.2.2"

self.sources = {
    { "source", "https://ftp.gnu.org/gnu/mpfr/mpfr-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix=')
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/lib filesystem")
end

return self
