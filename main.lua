pcall(require, "luarocks.loader")

function pkg(module)
    local name = module
    module = require("pickle-linux." .. module)
    if not module.name then
        local i, repository = name:match(".*%.()")
        if i ~= nil then
            repository = name:sub(1, i - 2)
            name = name:sub(i)
        end
        module.repository, module.name = repository, name
    end
    return module
end

local lfs = require "lfs"
local llby = require "lullaby"

local self = {}
local built_packages = {}

function self.get_file(name, version, variant)
    local file = name
    if variant then
        file = file .. "." .. variant
    end
    return file .. "," .. version .. ".sqsh"
end

local function pack(package, build_path, variant)
    -- create the filesystem
    local filesystem = "filesystem"
    if variant then
        filesystem = filesystem .. "-" .. variant.name
    end
    os.execute("rm -rf " .. filesystem)
    lfs.mkdir(filesystem)

    local ppack = variant
    if ppack then
        ppack = variant.pack
        if ppack then
            ppack()
        end
    else
        ppack = package.pack
        if ppack then
            ppack()
        end
    end

    if not ppack then
        return false
    end

    lfs.chdir(build_path)

    -- make the archive
    -- TODO: make the variant stuff more compact
    local vname = nil
    if variant then
        vname = variant.name
    end
    local file = self.get_file(package.name, package.version, vname)
    os.remove(file)
    os.execute("mksquashfs " .. filesystem .. " " .. file .. " -comp lzo -force-uid 0 -force-gid 0")

    return true
end
function self.build(repository, name, skip_dependencies)
    local archived = true

    local needed, og_path, package = true, lfs.currentdir(), pkg(repository .. "." .. name)

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

    -- TODO: detect packages directory automatically
    lfs.chdir("pickle-linux/" .. repository .. "/" .. name)
    local pkg_path = lfs.currentdir()
    if not lfs.attributes(".build") then
        lfs.mkdir(".build")
    elseif lfs.attributes(".build/" .. self.get_file(name, package.version)) then
        needed = false
    end
    lfs.chdir(".build")

    local build_path = lfs.currentdir()
    if needed then
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

        local build = package.build
        if build then
            build()
            lfs.chdir(build_path)
        end
    end

    archived = pack(package, build_path)

    if package.variants then
        for index, variant in pairs(package.variants) do
            variant.name = index

            local build = variant.build
            if build then
                build()
            end

            lfs.chdir(build_path)
            archived = pack(package, build_path, variant)

            built_packages[name .. "-" .. index] = true
        end
    end

    lfs.chdir(og_path)

    built_packages[name] = true

    return archived
end

function self.unpack(path, repository, name, variant)
    return os.execute("unsquashfs -d " ..
        path ..
        " -f pickle-linux/" ..
        repository .. "/" .. name .. "/.build/" .. self.get_file(name, pkg(repository .. "." .. name).version, variant))
end

return self
