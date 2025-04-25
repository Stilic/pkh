local tools = require "tools"

local self = {}

self.version = "5.2.37"
self.sources = {
    { "source", "https://ftp.gnu.org/gnu/bash/bash-" .. self.version .. ".tar.gz" }
}

self.build = tools.build_gnu_configure("", "--disable-nls --without-bash-malloc")
function self.pack()
    tools.pack_default()()
    os.execute("ln -s bash filesystem/bin/sh")
end

return self
