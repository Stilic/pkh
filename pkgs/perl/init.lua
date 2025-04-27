local lfs = require "lfs"
local system = require "system"
local tools = require "tools"

local self = {}

self.version = "5.40.2"
self.sources = {
    { "source", "https://www.cpan.org/src/" .. self.version:sub(1, 1) .. ".0/perl-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute(
        './Configure -des -Dprefix=/usr -Dman1ext=1p -Dman3ext=3p -Dman1dir=/usr/share/man/man1 -Dman3dir=/usr/share/man/man3 -Dccflags="' ..
        tools.DEFAULT_CFLAGS .. ' -Wno-implicit-function-declaration"')
    os.execute("make" .. system.get_make_jobs())
    os.execute("make install DESTDIR='" .. lfs.currentdir() .. "/_install'")
end

self.pack = tools.pack_default()

return self
