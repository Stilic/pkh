local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "14.2.0"

self.sources = {
    { "source", "https://ftp.gnu.org/gnu/gcc/gcc-" .. self.version .. "/gcc-" .. self.version .. ".tar.xz" }
}

function self.build()
    local build_dir = lfs.currentdir()
    lfs.chdir("source")
    lfs.mkdir("obj")
    lfs.chdir("obj")
    os.execute('../configure CFLAGS="-O2" --prefix= --disable-multilib')
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install-strip DESTDIR="' .. build_dir .. '/_install"')
end

function self.pack()
    os.execute(
        "cp -ra source/_install/lib source/_install/libexec source/_install/include source/_install/share source/_install/bin filesystem")
end

return self
