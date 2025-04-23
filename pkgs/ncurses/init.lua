local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "6.5"

self.sources = {
    { "source", "https://invisible-island.net/archives/ncurses/ncurses-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute(
        './configure CFLAGS="-O2" --prefix= --with-shared --with-normal --without-debug --with-termlib --disable-lib-suffixes')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
    os.execute("ln -s bash filesystem/bin/sh")
end

return self
