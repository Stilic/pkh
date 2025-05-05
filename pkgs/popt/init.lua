local tools = require "tools"

local self = {}

self.version = "1.19"
self.sources = {
    { "source", "https://ftp.osuosl.org/pub/rpm/popt/releases/popt-" .. self.version:sub(1, 1) .. ".x/popt-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
