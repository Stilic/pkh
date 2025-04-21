local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "14.2.0"

self.sources = {
    { "source", "https://ftp.gnu.org/gnu/gcc/gcc-" .. self.version .. "/gcc-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.mkdir("obj")
    lfs.chdir("obj")
    os.execute(
        '../source/configure CFLAGS="-O2" --prefix= --disable-multilib --disable-nls --with-system-zlib --enable-languages=c,c++')
    os.execute("make -j" .. system.buildCores)
    lfs.mkdir("_install")
    os.execute('make install-strip DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute(
        "cp -ra obj/_install/lib obj/_install/libexec obj/_install/include obj/_install/share obj/_install/bin filesystem")
    os.execute(
        "cp -ra obj/_install/lib64/* filesystem/lib")
end

return self
