local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.36.1"

self.sources = {
    { "source", "https://busybox.net/downloads/busybox-" .. self.version .. ".tar.bz2" }
}

self.out = { static = {} }

local function start_build()
    lfs.chdir("source")
    os.execute("cp ../../config .config")
end

local function end_build()
    os.execute('KCONFIG_NOTIMESTAMP=1 CFLAGS="-O2" make -j' .. system.buildCores)
    os.execute("make install")
end

function self.build()
    start_build()
    end_build()
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

function self.out.static.build()
    start_build()
    os.execute("sed -i 's/^CONFIG_STATIC=.*/CONFIG_STATIC=y/' .config")
    end_build()
end

return self
