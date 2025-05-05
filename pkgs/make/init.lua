local tools = require "tools"

local self = {}

self.version = "4.4.1"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/make/make-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
