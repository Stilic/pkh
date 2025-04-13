local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "8.13.0"

self.sources = {
    { "source", "https://curl.se/download/curl-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix= --with-openssl')
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    lfs.mkdir("filesystem/usr")
    os.execute("cp -ra source/_install/lib source/_install/bin filesystem/usr")
end

return self
