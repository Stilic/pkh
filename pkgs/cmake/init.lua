local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "4.0.1"

self.sources = {
    { "source", "https://github.com/Kitware/CMake/releases/download/v" .. self.version .. "/cmake-" .. self.version .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    local bootstrap_cmd = './bootstrap CFLAGS="-O2" --prefix=/usr'
    if system.build_cores ~= 1 then
        bootstrap_cmd = bootstrap_cmd .. " --parallel=" .. system.build_cores
    end
    os.execute(bootstrap_cmd)
    os.execute("make" .. system.get_make_jobs())
    lfs.mkdir("_install")
    os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
