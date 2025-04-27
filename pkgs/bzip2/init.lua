local lfs = require "lfs"
local system = require "system"
local tools = require "tools"

local self = {}

self.version = "1.0.8"
self.sources = {
    { "source", "https://sourceware.org/pub/bzip2/bzip2-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    local cflags = ' CFLAGS="' .. tools.DEFAULT_CFLAGS .. '" '
    os.execute("make libbz2.a bzip2 bzip2recover" .. cflags .. system.get_make_jobs())
    os.execute("make" .. cflags .. "-f Makefile-libbz2_so" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install PREFIX="' .. lfs.currentdir() .. '/_install/usr"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
    os.execute("cp source/libbz2.so." .. self.version .. " filesystem/usr/lib")
    os.execute("ln -s libbz2.so." .. self.version .. " filesystem/usr/lib/libbz2.so")
    os.execute("ln -s libbz2.so." .. self.version .. " filesystem/usr/lib/libbz2.so.1")
    os.execute("ln -s libbz2.so." .. self.version .. " filesystem/usr/lib/libbz2.so.1.0")
end

return self
