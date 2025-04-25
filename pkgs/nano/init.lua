local tools = require "tools"

local self = {}

self.version = "8.4"
self.sources = {
    { "source", "https://www.nano-editor.org/dist/v" .. self.version:sub(1, 1) .. "/nano-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure()
self.pack = tools.pack_default()

return self
