local tools = require "tools"

local self = {}

self.version = "3.13.3"
self.sources = {
    { "source", "https://www.python.org/ftp/python/" .. self.version .. "/Python-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure(nil, "--enable-shared --with-system-expat --without-ensurepip")
self.pack = tools.pack_default()

return self
