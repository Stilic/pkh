local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "3.5.0"

self.sources = {
    { "source", "https://github.com/openssl/openssl/releases/download/openssl-" .. self.version .. "/openssl-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./Configure CFLAGS="-O2" --prefix=/usr')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
    os.execute("mv filesystem/usr/lib64 filesystem/usr/lib")
end

return self
