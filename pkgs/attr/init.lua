local tools = require "tools"

local self = {}

self.version = "2.5.2"
self.sources = {
    { "source", "https://download.savannah.nongnu.org/releases/attr/attr-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
