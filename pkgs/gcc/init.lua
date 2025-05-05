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
        '../source/configure CFLAGS="-O2" --prefix=/usr --disable-multilib --disable-nls --with-system-zlib --with-native-system-header-dir=/include --enable-languages=c,c++')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install-strip DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra obj/_install/* filesystem")
    os.execute("mv filesystem/usr/lib64/* filesystem/usr/lib")
    os.execute("rm -r filesystem/usr/lib64")
    lfs.link("gcc", "filesystem/usr/bin/cc", true)
end

return self
