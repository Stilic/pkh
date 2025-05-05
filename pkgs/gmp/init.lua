local tools = require "tools"

local self = {}

self.version = "6.3.0"
self.sources = {
    { "source", "https://gmplib.org/download/gmp/gmp-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
