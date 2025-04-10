local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.36.1"

self.sources = {
    { "source", "https://busybox.net/downloads/busybox-" .. self.version .. ".tar.bz2" }
}

function self.build()
    lfs.chdir("source")
    os.execute("cp ../../config .config")
    os.execute("KCONFIG_NOTIMESTAMP=1 make -j" .. system.buildCores)
    os.execute("make install")
end

function self.pack()
    os.execute("cp -ra source/_install/bin filesystem")
end

return self
