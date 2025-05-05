local tools = require "tools"

local self = {}

self.version = "3.12"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/grep/grep-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("")
self.pack = tools.pack_default()

return self
