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
    -- TODO: add config for other architectures than x86_64
    os.execute("cp ../../config .config")
    os.execute('KCONFIG_NOTIMESTAMP=1 CFLAGS="-O2" make' .. system.get_make_jobs())
end

function self.pack()
    lfs.chdir("source")
    local path = "../filesystem/lib/modules/" .. system.capture("make -s kernelrelease")
    os.execute("mkdir -p " .. path)
    os.execute("cp -ra " .. system.capture("make -s image_name") .. " " .. path .. "/vmlinuz")
    os.execute(
        "ZSTD_CLEVEL=19 make INSTALL_MOD_PATH=../filesystem INSTALL_MOD_STRIP=1 DEPMOD=/doesnt/exist modules_install")
    os.remove(path .. "/build")

    -- TODO: put headers in a different package
    os.execute('make headers_install ARCH="' .. system.capture("arch") .. '"')
    os.execute("cp -ra usr/include ../filesystem")
end

return self
