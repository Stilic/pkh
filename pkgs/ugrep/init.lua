local tools = require "tools"

local self = {}

self.version = "7.4.1"
self.sources = {
    { "source", "https://github.com/Genivia/ugrep/archive/refs/tags/v" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure()
function self.pack()
    tools.pack_default()()
    
end

return self
