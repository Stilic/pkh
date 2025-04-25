local tools = require "tools"

local self = {}

self.version = "4.2"
self.sources = {
    { "source", "https://github.com/dosfstools/dosfstools/releases/download/v" .. self.version .. "/dosfstools-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
