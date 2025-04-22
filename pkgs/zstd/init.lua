local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.5.7"

self.sources = {
    { "source", "https://github.com/facebook/zstd/releases/download/v" .. self.version .. "/zstd-" .. self.version .. ".tar.zst" }
}

-- TODO: figure out why we cannot use --prefix
function self.build()
    lfs.chdir("source")
    os.execute('./configure CFLAGS="-O2"')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    lfs.mkdir("filesystem/usr")
    os.execute("cp -ra source/_install/usr/local/* filesystem/usr")
end

return self
