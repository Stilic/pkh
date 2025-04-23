local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "0.12.1"

self.sources = {
    { "source", "https://github.com/ifupdown-ng/ifupdown-ng/archive/refs/tags/ifupdown-ng-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
