local tools = require "tools"

local self = {}

self.version = "2.72"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/autoconf/autoconf-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
