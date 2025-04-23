local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "5.40.2"

self.sources = {
    { "source", "https://www.cpan.org/src/" .. self.version:sub(1, 1) .. ".0/perl-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute('./Configure -des -Dprefix="' ..
        lfs.currentdir() .. '/_install/usr"')
    os.execute('make CFLAGS="-DNO_POSIX_2008_LOCALE -D_GNU_SOURCE" LDFLAGS="-Wl,-z,stack-size=2097152"' ..
    system.get_make_jobs())
    os.execute("make install")
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
