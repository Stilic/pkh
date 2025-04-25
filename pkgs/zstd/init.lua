local lfs = require "lfs"
local tools = require "tools"

local self = {}

self.version = "1.5.7"
self.sources = {
    { "source", "https://github.com/facebook/zstd/releases/download/v" .. self.version .. "/zstd-" .. self.version .. ".tar.zst" }
}

self.build = tools.build_gnu_configure()
function self.pack()
    lfs.mkdir("filesystem/usr")
    os.execute("cp -ra source/_install/usr/local/* filesystem/usr")
end

return self
