local lfs = require "lfs"
local tools = require "tools"

local self = {}

self.version = "3.11.1"
self.sources = {
    { "source", "https://luarocks.github.io/luarocks/releases/luarocks-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    tools.make()
end

function self.pack()
    -- TODO: rework this
    os.execute("mkdir -p filesystem/etc/luarocks filesystem/usr/bin filesystem/usr/share/lua/5.4")
    os.execute("cp -ra source/build/config*.lua filesystem/etc/luarocks")
    os.execute("chmod +x source/build/luarocks*")
    os.execute("cp -ra source/build/luarocks* filesystem/usr/bin")
    os.execute("cp -ra source/src/luarocks filesystem/usr/share/lua/5.4")
end

return self
