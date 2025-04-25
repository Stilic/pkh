local tools = require "tools"

local self = {}

self.version = "1.47.1"
self.sources = {
    { "source", "https://mirrors.edge.kernel.org/pub/linux/kernel/people/tytso/e2fsprogs/v" ..
    self.version .. "/e2fsprogs-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure(nil, nil, nil, "-Wno-implicit-function-declaration")
self.pack = tools.pack_default()

return self
