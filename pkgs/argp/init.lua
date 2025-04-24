local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.5.0"

self.sources = {
    { "source", "https://github.com/argp-standalone/argp-standalone/archive/refs/tags/" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("autoreconf -vif")
    os.execute('./configure CFLAGS="-O2" --prefix=')
    os.execute("make" .. system.get_make_jobs())
end

function self.pack()
    lfs.mkdir("filesystem/include")
    os.execute("cp source/argp.h filesystem/include/argp.h")

    lfs.mkdir("filesystem/lib")
    os.execute("cp source/libargp.a filesystem/lib/libargp.a")
end

return self
