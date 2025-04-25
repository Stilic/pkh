local tools = require "tools"

local self = {}

self.version = "2.6.0"
self.sources = {
    { "source", "https://github.com/seccomp/libseccomp/releases/download/v" .. self.version .. "/libseccomp-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
