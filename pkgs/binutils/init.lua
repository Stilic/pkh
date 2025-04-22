local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "2.44"

self.sources = {
    { "source", "https://ftp.gnu.org/gnu/binutils/binutils-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix= --disable-nls')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/lib source/_install/include source/_install/share source/_install/bin filesystem")
end

return self
