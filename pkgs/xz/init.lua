local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "5.8.1"

self.sources = {
    { "source", "https://github.com/tukaani-project/xz/releases/download/v" .. self.version .. "/xz-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix=')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
