local tools = require "tools"

local self = {}

self.version = "5.3.2"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/gawk/gawk-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
