local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "6.14.2"

self.sources = {
    { "source", "https://cdn.kernel.org/pub/linux/kernel/v"
    .. self.version:sub(1, self.version:find(".", 1, true) - 1)
    .. ".x/linux-" .. self.version .. ".tar.xz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("cp ../../config .config")
    os.execute('KCONFIG_NOTIMESTAMP=1 CFLAGS="-O2" make -j' .. system.buildCores)
end

function self.pack()
    lfs.chdir("source")
    local path = "../filesystem/usr/lib/modules/" .. system.capture("make -s kernelrelease")
    os.execute("mkdir -p " .. path)
    os.execute("cp -ra " .. system.capture("make -s image_name") .. " " .. path .. "/vmlinuz")
    os.execute(
        "ZSTD_CLEVEL=19 make INSTALL_MOD_PATH=../filesystem/usr INSTALL_MOD_STRIP=1 DEPMOD=/doesnt/exist modules_install")
    os.remove(path .. "/build")
end

return self
