local tools = require "tools"

local self = {}

self.version = "8.13.0"
self.sources = {
    { "source", "https://curl.se/download/curl-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure(nil, "--with-openssl")
self.pack = tools.pack_default()

return self
