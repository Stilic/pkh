pcall(require, "luarocks.loader")
require "global"

local lfs = require "lfs"
local llby = require "lullaby"
local tools = require "tools"
local config = require "neld.config"

local self = {}
local CWD = lfs.currentdir()
local MOUNT_PATH = CWD .. "/neld/.build/work/mnt"
local ROOT_PATH = MOUNT_PATH .. "/root"
local OVERLAY_PATH = MOUNT_PATH .. "/usr"
local MAX_GROUP_SIZE = 7
local built_packages = {}
local mountpoints = {}

local function prepare_overlay(overlay, packages, prebuilt)
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

        if overlay[p.name] then
            return
        end
        local mountpoint = MOUNT_PATH .. "/" .. p.name
        overlay[p.name] = mountpoint

        if mountpoints[p.name] then
            return
        end
        mountpoints[p.name] = mountpoint

        local pkg_base = "/.build/"
        if prebuilt then
            pkg_base = "neld" .. pkg_base
        else
            prepare_overlay(overlay, p.dev_dependencies)
            pkg_base = "pickle-linux/" .. p.repository .. "/" .. p.name .. pkg_base
        end
        prepare_overlay(overlay, p.dependencies, prebuilt)

        lfs.mkdir(mountpoint)
        os.execute("mount " .. pkg_base .. tools.get_file(p.name, p.version) .. " " .. mountpoint)
    end
end

local function overlay_group(group, index)
    local mountpoint = MOUNT_PATH .. "/grp" .. tostring(index)
    lfs.mkdir(mountpoint)
    os.execute("mount -t overlay overlay -o lowerdir=" .. table.concat(group, ":") .. " " .. mountpoint)
    return mountpoint
end

local function mount_overlay(mounts)
    local overlays = {}

    for i = 1, #mounts, MAX_GROUP_SIZE do
        local group = {}
        for j = i, math.min(i + MAX_GROUP_SIZE - 1, #mounts) do
            table.insert(group, mounts[j])
        end
        table.insert(overlays, overlay_group(group, i))
    end

    os.execute("mount -t overlay overlay -o lowerdir=" .. table.concat(overlays, ":") .. " " .. OVERLAY_PATH)
    return overlays
end

function self.init()
    lfs.mkdir(MOUNT_PATH)
    lfs.mkdir(ROOT_PATH)
    lfs.mkdir(OVERLAY_PATH)

    os.execute("mount neld/.build/work/rootfs.sqsh " .. ROOT_PATH)
    os.execute("mount --bind . " .. ROOT_PATH .. "/root")
end

function self.close()
    lfs.chdir(CWD)
    os.execute("umount " .. ROOT_PATH .. "/root")
    os.execute("umount " .. ROOT_PATH)
    for _, m in pairs(mountpoints) do
        os.execute("umount " .. m)
    end
end

function self.build(repository, name, skip_dependencies)
    local rebuild, package = true, pkg(repository .. "." .. name)

    if not skip_dependencies then
        if package.dev_dependencies then
            for _, p in ipairs(package.dev_dependencies) do
                local pname = p.name
                if not built_packages[pname] then
                    self.build(p.repository, pname)
                end
            end
        end
        if package.dependencies then
            for _, p in ipairs(package.dependencies) do
                local pname = p.name
                if not built_packages[pname] then
                    self.build(p.repository, pname)
                end
            end
        end
    end

    local overlay = {}

    -- TODO: add support for variants
    prepare_overlay(overlay, config.user_packages, true)
    prepare_overlay(overlay, package.dev_dependencies)
    prepare_overlay(overlay, package.dependencies)

    local mounts = {}
    for _, m in pairs(overlay) do
        table.insert(mounts, m)
    end
    local overlays = mount_overlay(mounts)

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

    if rebuild and package.sources then
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

    lfs.chdir(CWD)

    os.execute(
        "bwrap --unshare-ipc --unshare-pid --unshare-net --unshare-uts --unshare-cgroup-try --clearenv --setenv PATH /usr/libexec/gcc/x86_64-pc-linux-musl/14.2.0:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --chdir /root --ro-bind "
        .. ROOT_PATH ..
        " / --dev /dev --tmpfs /tmp --ro-bind " .. OVERLAY_PATH .. " /usr --bind " .. build_path .. " /root/" ..
        build_suffix .. " /bin/lua untrusted_build.lua " .. repository .. " " .. name .. (rebuild and " 1" or " 0")
    )

    if package.variants then
        for index, _ in pairs(package.variants) do
            built_packages[name .. "-" .. index] = true
        end
    end
    built_packages[name] = true

    os.execute("umount " .. OVERLAY_PATH)
    for _, o in ipairs(overlays) do
        lfs.rmdir(o)
        os.execute("umount " .. o)
    end
end

function self.unpack(path, repository, name, variant)
    return os.execute("unsquashfs -d " ..
        path ..
        " -f pickle-linux/" ..
        repository .. "/" .. name .. "/.build/" ..
        tools.get_file(name, pkg(repository .. "." .. name).version, variant))
end

return self
