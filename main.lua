pcall(require, "luarocks.loader")
require "global"

local lfs = require "lfs"
local llby = require "lullaby"
local tools = require "tools"

local self = {}
local built_packages = {}

function self.build(repository, name, skip_dependencies)
    local base_path, rebuild, package = lfs.currentdir(), true, pkg(repository .. "." .. name)

    if not skip_dependencies then
        -- TODO: install the packages
        if package.dev_dependencies then
            for _, p in ipairs(package.dev_dependencies) do
                local name = p.name
                if not built_packages[name] then
                    self.build(p.repository, name)
                end
            end
        end
        if package.dependencies then
            for _, p in ipairs(package.dependencies) do
                local name = p.name
                if not built_packages[name] then
                    self.build(p.repository, name)
                end
            end
        end
    end

    local build_suffix = "pickle-linux/" .. repository .. "/" .. name
    lfs.chdir(build_suffix)
    local pkg_path = lfs.currentdir()
    if not lfs.attributes(".build") then
        lfs.mkdir(".build")
    elseif lfs.attributes(".build/" .. tools.get_file(name, package.version)) then
        rebuild = false
    end
    lfs.chdir(".build")
    build_suffix = build_suffix .. "/.build"
    local build_path = lfs.currentdir()

    if rebuild then
        if package.sources then
            for _, source in ipairs(package.sources) do
                local path, url = source[1], source[2]
                if not lfs.attributes(path) then
                    local req = llby.net.srequest(url)
                    while req.Location ~= nil do
                        url = req.Location
                        req = llby.net.srequest(url)
                    end
                    req.content:file("S" .. path)
                    os.execute("rm -rf " .. path)
                    lfs.mkdir(path)

                    local extension = string.sub(url, -4)
                    if extension == ".zip" or extension == ".whl" then
                        os.execute("unzip S" .. path .. " -d " .. path)
                    else
                        os.execute("tar xf S" .. path .. " --strip-components=1 -C " .. path)
                    end

                    local patch_dir = pkg_path .. "/" .. path
                    if not lfs.attributes(patch_dir) then
                        if path == "source" then
                            patch_dir = nil
                        else
                            patch_dir = pkg_path .. "/source"
                            if not lfs.attributes(patch_dir) then
                                patch_dir = nil
                            end
                        end
                    end
                    if patch_dir then
                        for file in lfs.dir(patch_dir) do
                            if file ~= "." and file ~= ".." then
                                os.execute("patch -d " .. path .. " -p1 -i " .. patch_dir .. "/" .. file)
                            end
                        end
                    end
                end
            end
        end
    end

    lfs.chdir(base_path)

    os.execute("bwrap --chdir /pkh --ro-bind /bin /bin --ro-bind /lib /lib --ro-bind /sbin /sbin --ro-bind . /pkh --bind " ..
        build_path ..
        " /pkh/" ..
        build_suffix .. " /bin/lua untrusted_build.lua " .. repository .. " " .. name .. " " .. (rebuild and "1" or "0"))

    if package.variants then
        for index, _ in pairs(package.variants) do
            built_packages[name .. "-" .. index] = true
        end
    end
    built_packages[name] = true
end

function self.unpack(path, repository, name, variant)
    return os.execute("unsquashfs -d " ..
        path ..
        " -f pickle-linux/" ..
        repository .. "/" .. name .. "/.build/" .. tools.get_file(name, pkg(repository .. "." .. name).version, variant))
end

return self
