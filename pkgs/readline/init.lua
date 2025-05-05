local lfs = require "lfs"
local tools = require "tools"

local self = {}

self.version = "8.2.13"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/readline/readline-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure(nil, "--with-curses bash_cv_termcap_lib=libcurses")
function self.pack()
    tools.pack_default()()
    lfs.rmdir("filesystem/usr/bin")
end

return self
