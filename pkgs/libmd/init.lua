local tools = require "tools"

local self = {}

self.version = "1.1.0"
self.sources = {
    { "source", "https://archive.hadrons.org/software/libmd/libmd-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
