local tools = require "tools"

local self = {}

self.version = "1.65.0"
self.sources = {
    { "source", "https://github.com/nghttp2/nghttp2/releases/download/v" .. self.version .. "/nghttp2-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
