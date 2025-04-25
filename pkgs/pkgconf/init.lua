local tools = require "tools"

local self = {}

self.version = "2.4.3"
self.sources = {
    { "source", "https://distfiles.ariadne.space/pkgconf/pkgconf-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure()
function self.pack()
    tools.pack_default()()
    os.execute("ln -sf pkgconf filesystem/usr/bin/pkg-config")
end

return self
