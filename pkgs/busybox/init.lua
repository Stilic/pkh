local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.36.1"

self.sources = {
    { "source", "https://busybox.net/downloads/busybox-" .. self.version .. ".tar.bz2" }
}

self.out = { static = {} }

local function build_start()
    lfs.chdir("source")
    os.execute("cp ../../config .config")
end

local function build_end()
    os.execute('KCONFIG_NOTIMESTAMP=1 CFLAGS="-O2" make -j' .. system.buildCores)
    os.execute("make install")
end

function self.out.static.build()
    build_start()
    os.execute("sed -i 's/^CONFIG_STATIC=.*/CONFIG_STATIC=y/' .config")
    build_end()
end

function self.build()
    build_start()
    build_end()
end

function self.pack()
    os.execute("cp -ra source/_install/bin/* filesystem")
end

return self
