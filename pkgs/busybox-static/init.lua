local tools = require "tools"

local self = {}

self.version = "1.36.1"
self.sources = {
    { "source", "https://busybox.net/downloads/busybox-" .. self.version .. ".tar.bz2" }
}

function self.build()
    tools.build_kconfig()()
    os.execute("make install")
end

self.pack = tools.pack_default()

return self
