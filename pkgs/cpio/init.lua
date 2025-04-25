local tools = require "tools"

local self = {}

self.version = "2.15"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/cpio/cpio-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
