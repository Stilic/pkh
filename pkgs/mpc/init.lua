local tools = require "tools"

local self = {}

self.version = "1.3.1"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/mpc/mpc-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
