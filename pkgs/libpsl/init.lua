local tools = require "tools"

local self = {}

self.version = "0.21.5"
self.sources = {
    { "source", "https://github.com/rockdaboot/libpsl/releases/download/" .. self.version .. "/libpsl-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
