local tools = require "tools"

local self = {}

self.version = "2.10"
self.sources = {
    { "source", "https://www.oberhumer.com/opensource/lzo/download/lzo-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure(nil, "--enable-shared")
self.pack = tools.pack_default()

return self
