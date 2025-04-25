local tools = require "tools"

local self = {}

self.version = "4.4.38"
self.sources = {
    { "source", "https://github.com/besser82/libxcrypt/releases/download/v" .. self.version .. "/libxcrypt-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
