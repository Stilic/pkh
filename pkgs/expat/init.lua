local tools = require "tools"

local self = {}

self.version = "2.7.1"
self.sources = {
    { "source", "https://github.com/libexpat/libexpat/releases/download/R_" .. self.version:gsub("%.", "_") .. "/expat-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure(nil, nil, nil, nil, "-DXML_LARGE_SIZE")
self.pack = tools.pack_default()

return self
