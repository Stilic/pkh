local tools = require "tools"

local self = {}

self.version = "3.49.1"
self.sources = {
    { "source", "https://sqlite.org/2025/sqlite-autoconf-3490100.tar.gz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
