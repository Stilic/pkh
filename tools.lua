local lfs = require "lfs"
local system = require "system"

local self = {}

self.DEFAULT_CFLAGS = "-O2 -fPIC"
self.DEFAULT_CPPFLAGS = self.DEFAULT_CFLAGS

function self.get_file(name, version, variant)
    local file = name
    if variant then
        file = file .. "." .. variant
    end
    return file .. "," .. version .. ".sqsh"
end

function self.get_flags(cflags, cppflags)
    return (hostfs and "CC=gcc CXX=g++" or "CC=clang CXX=clang++") ..
        ' CPATH=/usr/include CFLAGS="' ..
        self.DEFAULT_CFLAGS ..
        (cflags and (" " .. cflags) or "") ..
        '" CPPFLAGS="' .. self.DEFAULT_CPPFLAGS .. (cppflags and (" " .. cppflags) or "") .. '"'
end

function self.make(options, cflags, cppflags, configure)
    if options then
        options = " " .. options
    else
        options = ""
    end
    if not configure then
        configure = "configure"
    end

    if lfs.attributes(configure) then
        os.execute(self.get_flags(cflags, cppflags) .. " ./" .. configure .. " --prefix=" .. options)
        os.execute("CPATH=/usr/include make" .. system.get_make_jobs())
    else
        os.execute(self.get_flags(cflags, cppflags) .. " make" .. system.get_make_jobs() .. options)
    end
end

-- build templates

function self.build_gnu_configure(options, source, cflags, cppflags, configure)
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        self.make(options, cflags, cppflags, configure)

        lfs.mkdir("_install")
        os.execute('make install DESTDIR="' .. lfs.currentdir() .. '/_install"')
    end
end

function self.build_autotools(options, source, cflags, cppflags)
    if not source then
        source = "source"
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        os.execute("autoreconf -vif")
        self.build_gnu_configure(options, "", cflags, cppflags)()
    end
end

function self.build_meson(options, source, cflags, cppflags)
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

        os.execute(self.get_flags(cflags, cppflags) ..
            " meson setup build --buildtype=release --prefix=/ --libdir=/lib" .. options)
        os.execute("meson compile -C build")
        os.execute('DESTDIR="' .. lfs.currentdir() .. '/_install" meson install -C build')
    end
end

function self.build_cmake(options, source, project, cflags, cppflags)
    if options then
        options = " " .. options
    else
        options = ""
    end
    if not source then
        source = "source"
    end
    if not project then
        project = ""
    end

    local project_command, build_dir = "", "build"
    if project ~= "" then
        project_command = " -S " .. project .. " "
        build_dir = build_dir .. "-" .. project
    end

    return function()
        if source ~= "" then
            lfs.chdir(source)
        end

        os.execute(self.get_flags(cflags, cppflags) ..
            " cmake" ..
            project_command ..
            "-B " .. build_dir .. " -GNinja -DCMAKE_BUILD_TYPE=Release -DCMAKE_INSTALL_PREFIX=_install" .. options)
        os.execute("cmake --build " .. build_dir .. " --config Release --target install" .. system.get_make_jobs())
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

        os.execute(env .. "python -m gpep517 build-wheel --output-fd 1 --wheel-dir dist")
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

function self.pack_default(path, variant)
    if not path then
        path = "source/_install"
    end
    if variant then
        variant = "-" .. variant
    else
        variant = ""
    end

    return function()
        os.execute("cp -ra " .. path .. "/* filesystem" .. variant)
    end
end

function self.pack_python(path)
    if not path then
        path = "source"
    end

    return function()
        os.execute("python -m installer --prefix / -d filesystem " .. path .. "/dist/*.whl")
    end
end

return self
