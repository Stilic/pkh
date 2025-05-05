local tools = require "tools"

local self = {}

self.version = "4.9"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/sed/sed-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
