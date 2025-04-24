local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "8.4"

self.sources = {
    { "source", "https://www.nano-editor.org/dist/v" .. self.version:sub(1, 1) .. "/nano-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix=/usr')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
