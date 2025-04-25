local tools = require "tools"

local self = {}

self.version = "0.192"
self.sources = {
    { "source", "https://sourceware.org/elfutils/ftp/" .. self.version .. "/elfutils-" .. self.version .. ".tar.bz2" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
