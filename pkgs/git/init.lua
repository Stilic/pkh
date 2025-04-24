local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "2.49.0"

self.sources = {
    { "source", "https://www.kernel.org/pub/software/scm/git/git-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("make configure")
    os.execute('./configure CFLAGS="-O2" --prefix=/usr')
    -- TODO: add asciidoc
    os.execute("make all" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
