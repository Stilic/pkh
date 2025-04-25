local tools = require "tools"

local self = {}

self.version = "1.4.19"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/m4/m4-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
