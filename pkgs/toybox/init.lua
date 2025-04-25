local tools = require "tools"

local self = {}

self.version = "0.8.12"
self.sources = {
    { "source", "https://landley.net/toybox/downloads/toybox-" .. self.version .. ".tar.gz" }
}

function self.build()
    tools.build_kconfig()()
    os.execute("make install")
end

self.pack = tools.pack_default("source/install")

return self
