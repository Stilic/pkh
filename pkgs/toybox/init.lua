local lfs = require "lfs"

local self = {}

self.version = "0.8.12"

self.sources = {
    { "source", "https://landley.net/toybox/downloads/toybox-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("cp ../../config .config")
    os.execute('KCONFIG_NOTIMESTAMP=1 CFLAGS="-O2" make')
    os.execute("make install")
end

function self.pack()
    os.execute("cp -ra source/install/* filesystem")
end

return self
