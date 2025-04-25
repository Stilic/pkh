local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "0.3.2"
self.sources = {
    { "source", "http://ftp.barfooze.de/pub/sabotage/tarballs/netbsd-curses-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    lfs.mkdir("_install")
    os.execute('make CFLAGS="-O2" PREFIX=/usr DESTDIR="' ..
        lfs.currentdir() .. '/_install"' .. system.get_make_jobs() .. ' all install')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
    -- TODO: check if this fixes compat everywhere
    lfs.chdir("filesystem/usr/lib")
    lfs.link("libterminfo.so", "libtinfo.so", true)
    lfs.link("libterminfo.so", "libtinfow.so", true)
    for file in lfs.dir(".") do
        if file:match("%.so") then
            lfs.link(file, file .. ".6", true)
        end
    end
end

return self
