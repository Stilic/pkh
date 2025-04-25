local lfs = require "lfs"
local tools = require "tools"

local self = {}

self.version = "1.2.3"
self.sources = {
    { "source", "https://github.com/void-linux/musl-obstack/archive/refs/tags/v" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("./bootstrap.sh")
    tools.build_gnu_configure("", nil, "")()
end

self.pack = tools.pack_default()

return self
