local tools = require "tools"

local self = {}

self.version = "2.5.4"
self.sources = {
    { "source", "https://ftpmirror.gnu.org/libtool/libtool-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
