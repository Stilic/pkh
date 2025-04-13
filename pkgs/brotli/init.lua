local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "1.1.0"

self.sources = {
    { "source", "https://github.com/google/brotli/archive/refs/tags/v" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    lfs.mkdir("out")
    lfs.chdir("out")
    os.execute("cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=installed ..")
    os.execute("cmake --build . --config Release --target install")
end

function self.pack()
    lfs.mkdir("filesystem/usr")
    os.execute("cp -ra source/out/installed/lib64 filesystem/usr/lib")
    os.execute("cp -ra source/out/installed/bin filesystem/usr")
end

return self
