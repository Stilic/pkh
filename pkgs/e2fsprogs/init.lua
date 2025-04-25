local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.47.1"

self.sources = {
    { "source", "https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v" ..
    self.version .. "/e2fsprogs-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2 -Wno-implicit-function-declaration" --prefix=/usr')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
