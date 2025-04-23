local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "5.2.37"

self.sources = {
    { "source", "https://ftp.gnu.org/gnu/bash/bash-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2" --prefix= --disable-nls --without-bash-malloc')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
    os.execute("ln -s bash filesystem/bin/sh")
end

return self
