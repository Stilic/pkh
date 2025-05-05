local tools = require "tools"

local self = {}

self.version = "0.8.12"
self.sources = {
    { "source", "https://landley.net/toybox/downloads/toybox-" .. self.version .. ".tar.gz" }
}

function self.build()
    tools.build_kconfig()()
    os.execute("make install")
end

function self.pack()
    os.execute("cp -ra source/install/bin source/install/sbin filesystem")
    os.execute("cp -ra source/install/usr/bin source/install/usr/sbin filesystem")
end

return self
