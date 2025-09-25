local lfs = require "lfs"
local system = require "system"

local self = {}

self.DEFAULT_CFLAGS = "-O2 -fPIC"
self.DEFAULT_CPPFLAGS = self.DEFAULT_CFLAGS

-- TODO: remove CC
function self.get_flags(cflags, cppflags)
    return 'CC=gcc CFLAGS="' ..
        self.DEFAULT_CFLAGS ..
        (cflags and (" " .. cflags) or "") ..
        '" CPPFLAGS="' .. self.DEFAULT_CPPFLAGS .. (cppflags and (" " .. cppflags) or "") .. '"'
end

function self.make(prefix, options, cflags, cppflags, configure)
    if not prefix then
        prefix = "/usr"
    end
    if options then
        options = " " .. options
    else
        options = ""
    end
    if not configure then
        configure = "configure"
    end

    if lfs.attributes(configure) then
        os.execute(self.get_flags(cflags, cppflags) .. " ./" .. configure .. " --prefix=" .. prefix .. options)
        os.execute("make" .. system.get_make_jobs())
    else
        os.execute(self.get_flags(cflags, cppflags) .. " make" .. system.get_make_jobs() .. options)
    end
end

-- build templates

function self.build_gnu_configure(prefix, options, source, cflags, cppflags, configure)
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        self.make(prefix, options, cflags, cppflags, configure)

        lfs.mkdir("_install")
        os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
    end
end

function self.build_autotools(prefix, options, source, cflags, cppflags)
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        os.execute("autoreconf -vif")
        self.build_gnu_configure(prefix, options, "", cflags, cppflags)()
    end
end

function self.build_meson(prefix, options, source, cflags, cppflags)
    if not prefix then
        prefix = "/usr"
    end
    if options then
        options = " " .. options
    else
        options = ""
    end
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        os.execute(self.get_flags(cflags, cppflags) .. " meson setup build --prefix=" .. prefix .. options)
        os.execute("meson compile -C build")
        os.execute('DESTDIR="' .. lfs.currentdir() .. '/_install" meson install -C build')
    end
end

function self.build_cmake(prefix, options, source, cflags, cppflags)
    if not prefix then
        prefix = "/usr"
    end
    if options then
        options = " " .. options
    else
        options = ""
    end
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        local install_dir = "_install" .. prefix
        os.execute(self.get_flags(cflags, cppflags) ..
            " cmake -B build -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=" .. install_dir .. options)
        os.execute("cmake --build build --config Release --target install" .. system.get_make_jobs())
        os.execute("mv " .. install_dir .. "/lib64 " .. install_dir .. "/lib")
    end
end

function self.build_python(source, env)
    if not source then
        source = "source"
    end
    if env then
        env = env .. " "
    else
        env = ""
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        os.execute(env .. "python -m build --wheel --no-isolation")
    end
end

function self.build_flit(source)
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        os.execute("python -m flit_core.wheel")
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
        os.execute("make olddefconfig")
        os.execute("KCONFIG_NOTIMESTAMP=1 " .. self.get_flags(cflags, cppflags) .. " make" .. system.get_make_jobs())
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

function self.pack_python(path)
    if not path then
        path = "source"
    end

    return function()
        os.execute("python -m installer -d filesystem " .. path .. "/dist/*.whl")
    end
end

return self
