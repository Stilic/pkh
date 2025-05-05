local tools = require "tools"

local self = {}

self.version = "2.44"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/binutils/binutils-" .. self.version .. ".tar.xz" }
}

self.build = tools.build_gnu_configure(nil, "--disable-nls")
function self.pack()
    os.execute(
        "cp -ra source/_install/usr/lib source/_install/usr/include source/_install/usr/share source/_install/usr/bin filesystem")
end

return self
