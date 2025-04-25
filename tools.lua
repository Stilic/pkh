local lfs = require "lfs"
local system = require "system"

local self = {}

self.default_cflags = "-O2"
self.default_cppflags = self.default_cflags

function self.get_flags(cflags, cppflags)
    return ' CFLAGS="' ..
        self.default_cflags ..
        (cflags and (" " .. cflags) or "") ..
        '" CPPFLAGS="' .. self.default_cppflags .. (cppflags and (" " .. cppflags) or "") .. '" '
end

function self.make(prefix, options, cflags, cppflags)
    if not prefix then
        prefix = "/usr"
    end
    if options then
        options = options .. " "
    else
        options = ""
    end

    os.execute("./configure" .. self.get_flags(cflags, cppflags) .. options .. "--prefix=" .. prefix)
    os.execute("make" .. system.get_make_jobs())
end

-- build templates

function self.build_gnu_configure(prefix, options, source, cflags, cppflags)
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        self.make(prefix, options, cflags, cppflags)

        lfs.mkdir("_install")
        os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
    end
end

function self.build_kconfig(source, cflags, cppflags)
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        os.execute("cp ../../config .config")
        os.execute("make" .. system.get_make_jobs() .. "KCONFIG_NOTIMESTAMP=1" .. self.get_flags(cflags, cppflags))
    end
end

-- pack templates

function self.pack_default(path)
    if not path then
        path = "source/_install"
    end

    return function()
        os.execute("cp -ra " .. path .. "/* filesystem")
    end
end

return self
