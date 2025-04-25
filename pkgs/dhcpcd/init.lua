local tools = require "tools"

local self = {}

self.version = "10.2.2"
self.sources = {
    { "source", "https://github.com/NetworkConfiguration/dhcpcd/releases/download/v" .. self.version .. "/dhcpcd-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
