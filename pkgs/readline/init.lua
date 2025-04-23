local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "8.2.13"

self.sources = {
    { "source", "https://ftp.gnu.org/gnu/readline/readline-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute(
    './configure CFLAGS="-O2" --prefix=/usr --disable-static --enable-multibyte --with-curses bash_cv_termcap_lib=libncurses')
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
    lfs.rmdir("filesystem/bin")
end

return self
