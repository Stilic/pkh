local lfs = require "lfs"
local system = require "system"

local self = {}

self.version = "6.0"

self.sources = {
    { "source", "https://downloads.sourceforge.net/infozip/unzip" .. self.version:gsub("%.", "") .. ".tar.gz" }
}

function self.build()
    lfs.chdir("source")
    os.execute("make" .. system.get_make_jobs() ..
        ' -f unix/Makefile CF="-O2 -I. -DWILD_STOP_AT_DIR -DLARGE_FILE_SUPPORT -DUNICODE_SUPPORT -DUNICODE_WCHAR -DUTF8_MAYBE_NATIVE -DNO_LCHMOD -DDATE_FORMAT=DF_YMD -DNATIVE" unzips')
    os.execute('make -f unix/Makefile prefix="' .. lfs.currentdir() .. "/_install/usr" .. '" install')
end

function self.pack()
    os.execute("cp -ra source/_install/* filesystem")
end

return self
