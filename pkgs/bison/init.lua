local tools = require "tools"

local self = {}

self.version = "3.8.2"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/bison/bison-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
