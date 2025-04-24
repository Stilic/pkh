local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.2.3"

self.sources = {
    { "source", "https://github.com/void-linux/musl-obstack/archive/refs/tags/v" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("./bootstrap.sh")
    os.execute('./configure CFLAGS="-O2" --prefix=')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
