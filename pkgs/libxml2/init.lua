local lfs = require "lfs"
local tools = require "tools"

local self = {}

self.version = "2.14.2"
self.sources = {
    { "source", "https://download.gnome.org/sources/libxml2/" .. self.version:sub(1, 4) .. "/libxml2-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure(nil, "--enable-static --with-zlib")
function self.pack()
    tools.pack_default()()

    local file = "libxml2.so.16.0.2"
    lfs.link(file, "filesystem/usr/lib/libxml2.so." .. self.version:sub(1, 1), true)
    lfs.link(file, "filesystem/usr/lib/libxml2.so." .. self.version, true)
end

return self
