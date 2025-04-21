local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "2.3.8"

self.sources = {
    { "source", "https://ftp.gnu.org/gnu/libidn/libidn2-" .. self.version .. ".tar.gz" }
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
    os.execute("cp -ra source/_install/* filesystem/usr")
end

return self
