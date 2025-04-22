local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "2.49.0"

self.sources = {
    { "source", "https://www.kernel.org/pub/software/scm/git/git-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("make configure")
    os.execute('./configure CFLAGS="-O2" --prefix=/usr')
    os.execute("make all doc info -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install install-doc install-html install-info DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
