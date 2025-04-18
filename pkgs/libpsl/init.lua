local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "0.21.5"

self.sources = {
    { "source", "https://github.com/rockdaboot/libpsl/releases/download/" .. self.version .. "/libpsl-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix=')
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    lfs.mkdir("filesystem/usr")
    os.execute("cp -ra source/_install/lib filesystem/usr")
end

return self
