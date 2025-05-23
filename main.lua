require "luarocks.loader"

function pkg(module)
    local name = module
    module = require(module)
    if not module.name then
        local i = name:match(".*%.()")
        if i ~= nil then
            name = name:sub(i)
        end
        module.name = name
        print(name)
    end
    return module
end

local lfs = require "lfs"

local self = {}
local built_packages = {}

function self.get_file(name, version, variant)
    local file = name
    if variant then
        file = file .. "-" .. variant
    end
    return file .. "," .. version .. ".sqsh"
end

local function pack(package, build_path, variant)
    -- create the filesystem
    os.execute("rm -rf filesystem")
    lfs.mkdir("filesystem")

    local ppack = variant
    if ppack then
        ppack = variant.pack
        if ppack then
            ppack()
        end
    end
    if not ppack then
        ppack = package.pack
        if ppack then
            ppack()
        end
    end

    if not ppack then
        return false
    end

    lfs.chdir(build_path)

    if package.dependencies then
        local deps = io.open("filesystem/.deps", "w")
        if deps then
            local length = #package.dependencies
            for i, p in ipairs(package.dependencies) do
                deps:write(p.name .. "," .. p.version)
                if i ~= length then
                    deps:write("\n")
                end
            end
            deps:close()
        end
    end

    -- make the archive
    -- TODO: make the variant stuff more compact
    local vname = nil
    if variant then
        vname = variant.name
    end
    local file = self.get_file(package.name, package.version, vname)
    os.remove(file)
    os.execute("mksquashfs filesystem " .. file .. " -comp lzo -force-uid 0 -force-gid 0")

    return true
end
function self.build(repository, name)
    local archived = true

    local needed, og_path, package = true, lfs.currentdir(), pkg(repository .. "." .. name)

    -- TODO: install the packages
    if package.dev_dependencies then
        for _, p in package.dev_dependencies do
            if not built_packages[p] then
                self.build(p)
            end
        end
    end
    if package.dependencies then
        for _, p in package.dependencies do
            if not built_packages[p] then
                self.build(p)
            end
        end
    end

    lfs.chdir("pkgs/" .. name)
    local pkg_path = lfs.currentdir()
    if not lfs.attributes(".build") then
        lfs.mkdir(".build")
    elseif lfs.attributes(".build/" .. self.get_file(name, package.version)) then
        needed = false
    end
    lfs.chdir(".build")

    local build_path, pbuild = lfs.currentdir(), package.build
    if needed then
        for _, source in ipairs(package.sources) do
            local path = source[1]
            if not lfs.attributes(path) then
                os.execute("curl -Lo _" .. path .. " " .. source[2])
                os.execute("rm -rf " .. path)
                lfs.mkdir(path)
                os.execute("tar xf _" .. path .. " --strip-components=1 -C " .. path)

                local patch_dir = pkg_path .. "/" .. path
                if lfs.attributes(patch_dir) then
                    for file in lfs.dir(patch_dir) do
                        if file ~= "." and file ~= ".." then
                            os.execute("patch -d " .. path .. " -p1 -i " .. patch_dir .. "/" .. file)
                        end
                    end
                end
            end
        end

        if pbuild then
            pbuild()
            lfs.chdir(build_path)
        end
    end

    archived = pack(package, build_path)

    if package.out then
        for index, variant in pairs(package.out) do
            variant.name = index

            -- TODO: separate main package and variants environments
            if variant.build then
                variant.build()
            elseif pbuild then
                pbuild()
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
        path .. " -f pkgs/" .. name .. "/.build/" .. self.get_file(name, pkg(repository .. "." .. name).version, variant))
end

return self
