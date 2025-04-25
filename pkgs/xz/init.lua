local tools = require "tools"

local self = {}

self.version = "5.8.1"
self.sources = {
    { "source", "https://github.com/tukaani-project/xz/releases/download/v" .. self.version .. "/xz-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
