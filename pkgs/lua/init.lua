local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "5.4.7"
self.sources = {
    { "source", "https://www.lua.org/ftp/lua-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    -- TODO: see if we can add cflags there
    os.execute("make" .. system.get_make_jobs())
    os.execute("make local")
end

function self.pack()
    lfs.mkdir("filesystem/usr")
    os.execute("cp -ra source/install/* filesystem/usr")
    os.execute("ln -s /usr/bin/lua filesystem/usr/bin/lua" ..
        self.version:sub(1, self.version:find(".", self.version:find(".", 1, true) + 1, true) - 1))
end

return self
