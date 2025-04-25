local tools = require "tools"

local self = {}

self.version = "1.3.1"
self.sources = {
    { "source", "https://zlib.net/zlib-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
