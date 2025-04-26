local tools = require "tools"

local self = {}

self.version = "1.17"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/automake/automake-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
