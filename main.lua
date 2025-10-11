pcall(require, "luarocks.loader")
require "global"

local lfs = require "lfs"
local llby = require "lullaby"
local tools = require "tools"
local config = require "neld.config"

local self = {}
local built_packages = {}
local mnt_path = lfs.currentdir() .. "/neld/.build/work/mnt"
local overlay_path = mnt_path .. "/usr"

local function prepare_mount(mountpoints, packages, prebuilt)
    if not packages then
        return
    end

    for _, p in ipairs(packages) do
        if p.repository == "main" then
            return
        end

        if type(p) == "string" then
            p = pkg("user." .. p)
        end
        if mountpoints[p.name] then
            return
        end

        local pkg_base = "/.build/"
        if prebuilt then
            pkg_base = "neld" .. pkg_base
        else
            prepare_mount(mountpoints, p.dev_dependencies)
            pkg_base = "pickle-linux/" .. p.repository .. "/" .. p.name .. pkg_base
        end
        prepare_mount(mountpoints, p.dependencies, prebuilt)

        local mountpoint = mnt_path .. "/" .. p.name
        mountpoints[p.name] = mountpoint
        lfs.mkdir(mountpoint)
        os.execute("mount " .. pkg_base .. tools.get_file(p.name, p.version) .. " " .. mountpoint)

        print("MOUNTING: " .. p.name)
    end
end

function self.init()
    local root_path = mnt_path .. "/root"

    lfs.mkdir(mnt_path)
    lfs.mkdir(root_path)
    lfs.mkdir(overlay_path)

    os.execute("mount neld/.build/work/rootfs.sqsh " .. root_path)
    os.execute("mount --bind . " .. root_path .. "/root")
end

function self.close()
    os.execute("umount neld/.build/work/mnt/root")
end

function self.build(repository, name, skip_dependencies)
    local base_path, rebuild, package = lfs.currentdir(), true, pkg(repository .. "." .. name)

    if not skip_dependencies then
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

    local mountpoints = {}

    -- TODO: add support for variants
    prepare_mount(mountpoints, config.user_packages, true)
    prepare_mount(mountpoints, package.dev_dependencies)
    prepare_mount(mountpoints, package.dependencies)

    local lowerdir = ""
    for _, m in pairs(mountpoints) do
        lowerdir = lowerdir .. m .. ":"
    end
    if lowerdir ~= "" then
        os.execute("mount -t overlay overlay -o lowerdir=" .. lowerdir:sub(1, -2) .. " " .. overlay_path)
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

    local root_path = mnt_path .. "/root"
    os.execute(
        "bwrap --unshare-ipc --unshare-pid --unshare-net --unshare-uts --unshare-cgroup-try --clearenv --setenv PATH /usr/libexec/gcc/x86_64-pc-linux-musl/14.2.0:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --chdir /root --ro-bind "
        .. root_path ..
        " / --dev /dev --tmpfs /tmp" ..
        (lowerdir == "" and "" or (" --ro-bind " .. overlay_path .. " /usr")) ..
        " --bind " .. build_path .. " /root/" ..
        build_suffix .. " /bin/lua untrusted_build.lua " .. repository .. " " .. name .. " " .. (rebuild and "1" or "0"))

    if package.variants then
        for index, _ in pairs(package.variants) do
            built_packages[name .. "-" .. index] = true
        end
    end
    built_packages[name] = true

    for _, m in pairs(mountpoints) do
        os.execute("umount " .. m)
    end
    os.execute("umount " .. overlay_path)
end

function self.unpack(path, repository, name, variant)
    return os.execute("unsquashfs -d " ..
        path ..
        " -f pickle-linux/" ..
        repository .. "/" .. name .. "/.build/" .. tools.get_file(name, pkg(repository .. "." .. name).version, variant))
end

return self
