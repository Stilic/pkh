local tools = require "tools"

local self = {}

self.version = "2.44"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/binutils/binutils-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure("", "--disable-nls")
function self.pack()
    os.execute("cp -ra source/_install/lib source/_install/include source/_install/share source/_install/bin filesystem")
end

return self
