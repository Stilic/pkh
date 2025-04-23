local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "5.40.2"

self.sources = {
    { "source", "https://www.cpan.org/src/" .. self.version:sub(1, 1) .. ".0/perl-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("./Configure -des -Dccflags='-Wno-implicit-function-declaration' -Dprefix='" ..
        lfs.currentdir() .. "/_install/usr'")
    os.execute("make" .. system.get_make_jobs())
    os.execute("make install")
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
