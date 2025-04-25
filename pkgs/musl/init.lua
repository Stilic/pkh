local tools = require "tools"

local self = {}

self.version = "1.2.5"
self.sources = {
    { "source", "https://musl.libc.org/releases/musl-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
