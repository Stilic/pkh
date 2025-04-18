local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.2.5"

self.sources = {
    { "source", "https://musl.libc.org/releases/musl-" .. self.version .. ".tar.gz" }
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
