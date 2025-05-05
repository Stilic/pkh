local lfs = require "lfs"

local self = {}

self.version = "1.1.0"
self.sources = {
    { "source", "https://github.com/google/brotli/archive/refs/tags/v" .. self.version .. ".tar.gz" }
}

-- TODO: add cflags
function self.build()
    lfs.chdir("source")
    lfs.mkdir("out")
    lfs.chdir("out")
    os.execute("cmake -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=usr ..")
    os.execute("cmake --build . --config Release --target install")
end

function self.pack()
    os.execute("cp -ra source/out/usr filesystem")
    os.execute("mv filesystem/usr/lib64 filesystem/usr/lib")
end

return self
