local tools = require "tools"

local self = {}

self.version = "5.46"
self.sources = {
    { "source", "https://astron.com/pub/file/file-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure("", "--enable-static")
self.pack = tools.pack_default()

return self
