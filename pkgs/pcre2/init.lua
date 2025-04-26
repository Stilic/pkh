local tools = require "tools"

local self = {}

self.version = "10.45"
self.sources = {
    { "source", "https://github.com/PCRE2Project/pcre2/releases/download/pcre2-" ..
    self.version .. "/pcre2-" .. self.version .. ".tar.bz2" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
