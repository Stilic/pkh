local tools = require "tools"

local self = {}

self.version = "2.6.4"
self.sources = {
    { "source", "https://github.com/westes/flex/releases/download/v" .. self.version .. "/flex-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
