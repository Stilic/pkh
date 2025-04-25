local lfs = require "lfs"
local system = require "system"
local tools = require "tools"

local self = {}

self.version = "1.5.0"

self.sources = {
    { "source", "https://github.com/argp-standalone/argp-standalone/archive/refs/tags/" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("autoreconf -vif")
    tools.make("")
end

function self.pack()
    lfs.mkdir("filesystem/include")
    os.execute("cp source/argp.h filesystem/include/argp.h")

    lfs.mkdir("filesystem/lib")
    os.execute("cp source/libargp.a filesystem/lib/libargp.a")
end

return self
