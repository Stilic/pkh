local tools = require "tools"

local self = {}

self.version = "3.3"
self.sources = {
    { "source", "http://ftp.gnu.org/pub/gnu/gperf/gperf-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
