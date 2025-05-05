local tools = require "tools"

local self = {}

self.version = "2.41"
self.sources = {
    { "source", "https://www.kernel.org/pub/linux/utils/util-linux/v" .. self.version .. "/util-linux-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("", "--enable-newgrp --disable-more --disable-kill")
self.pack = tools.pack_default()

return self
