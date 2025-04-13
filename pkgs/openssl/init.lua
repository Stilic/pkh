local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "3.5.0"

self.sources = {
    { "source", "https://github.com/openssl/openssl/releases/download/openssl-" .. self.version .. "/openssl-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./Configure CFLAGS="-O2" --prefix=/')
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    lfs.mkdir("filesystem/usr")
    os.execute("cp -ra source/_install/lib64 filesystem/usr/lib")
    os.execute("cp -ra source/_install/bin source/_install/ssl filesystem/usr")
end

return self
