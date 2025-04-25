local tools = require "tools"

local self = {}

self.version = "1.18"
self.sources = {
    { "source", "https://ftp.gnu.org/pub/gnu/libiconv/libiconv-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
