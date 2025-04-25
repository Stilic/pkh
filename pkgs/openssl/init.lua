local lfs = require "lfs"
local tools = require "tools"

local self = {}

self.version = "3.5.0"
self.sources = {
    { "source", "https://github.com/openssl/openssl/releases/download/openssl-" .. self.version .. "/openssl-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.rename("Configure", "configure")
    tools.build_gnu_configure(nil, nil, "")()
end

function self.pack()
    tools.pack_default()()
    os.rename("filesystem/usr/lib64", "filesystem/usr/lib")
end

return self
