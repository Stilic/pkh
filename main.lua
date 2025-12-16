pcall(require, "luarocks.loader")
require "global"

local lfs = require "lfs"
local llby = require "lullaby"
local system = require "system"
local tools = require "tools"
local config = require "neld.config"

local self = { built_packages = {} }
local rootfs = {}
for _, package in ipairs(config.rootfs) do
    rootfs[package] = package
end

local cwd = lfs.currentdir()
local base_build_path = "." .. (stage == 0 and "bootstrap" or "build")
local mnt_path = cwd .. "/neld/" .. base_build_path .. "/work/mnt"
local root_path = mnt_path .. "/root"
local overlay_path = root_path .. "/usr"
local ro_path = mnt_path .. "/ro"
local mountpoints = {}

local function prepare_mounts(overlay, packages, prebuilt)
    for _, package in ipairs(packages) do
        if rootfs[package] then
            return
        end

        if type(package) == "string" then
            package = pkg(package)
        end

        local mountpoint = mnt_path .. "/" .. package.name
        overlay[package.name] = mountpoint

        local mnt = "/" .. base_build_path .. "/"
        if prebuilt then
            mnt = "neld" .. mnt
        else
            mnt = "pickle-linux/" .. package.name .. mnt
        end
        mnt = mnt .. tools.get_file(package.name, package.version)

        if not mountpoints[package.name] then
            lfs.mkdir(mountpoint)
            if os.execute("squashfuse " .. mnt .. " " .. mountpoint) then
                mountpoints[package.name] = mountpoint
            elseif package.dev_dependencies and not prebuilt then
                prepare_mounts(overlay, package.dev_dependencies)
            end
        end

        if package.dependencies then
            prepare_mounts(overlay, package.dependencies, prebuilt)
        end
    end
end

function self.close()
    lfs.chdir(cwd)
    if stage ~= 0 then
        os.execute("umount " .. root_path)
    end
    for _, m in pairs(mountpoints) do
        os.execute("umount " .. m)
    end
end

function self.build(name, skip_dependencies)
    if name:find("%.") then
        return
    end

    local package, process_main = pkg(name), true

    if not skip_dependencies then
        if stage ~= 0 and package.dev_dependencies then
            for _, p in ipairs(package.dev_dependencies) do
                local name = p.name
                if not self.built_packages[name] then
                    self.build(name)
                end
            end
        end
        if package.dependencies then
            for _, p in ipairs(package.dependencies) do
                local name = p.name
                if not self.built_packages[name] then
                    self.build(name)
                end
            end
        end
    end

    local overlay = {}

    if stage ~= 0 then
        -- TODO: add support for variants
        prepare_mounts(overlay, config.development, true)
        if package.dev_dependencies then
            prepare_mounts(overlay, package.dev_dependencies)
        end
        if package.dependencies then
            prepare_mounts(overlay, package.dependencies)
        end

        local lowerdir = ro_path .. ":"
        for _, m in pairs(overlay) do
            lowerdir = lowerdir .. m .. ":"
        end
        os.execute("fuse-overlayfs -o lowerdir=" .. lowerdir:sub(1, -2) .. " " .. overlay_path)
    end

    local build_suffix = "pickle-linux/" .. name
    lfs.chdir(build_suffix)
    local package_path = lfs.currentdir()
    if not lfs.attributes(base_build_path) then
        lfs.mkdir(base_build_path)
    elseif lfs.attributes(base_build_path .. "/" .. tools.get_file(name, package.version)) then
        process_main = false
    end
    lfs.chdir(base_build_path)
    build_suffix = build_suffix .. "/" .. base_build_path
    local build_path = lfs.currentdir()

    if process_main then
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

                    local patch_dir = package_path .. "/" .. path
                    if not lfs.attributes(patch_dir) then
                        if path == "source" then
                            patch_dir = nil
                        else
                            patch_dir = package_path .. "/source"
                            if not lfs.attributes(patch_dir) then
                                patch_dir = nil
                            end
                        end
                    end
                    if patch_dir then
                        lfs.chdir(path)
                        for file in lfs.dir(patch_dir) do
                            if file ~= "." and file ~= ".." then
                                os.execute("patch -p 1 -i " .. patch_dir .. "/" .. file)
                            end
                        end
                        lfs.chdir(build_path)
                    end
                end
            end
        end
    end

    lfs.chdir(cwd)

    local process_main_option = " 0"
    if process_main then
        process_main_option = " 1"
    end
    -- TODO: remove the gcc libexec workaround
    os.execute(
        "bwrap --unshare-ipc --unshare-pid --unshare-net --unshare-uts --unshare-cgroup-try --clearenv --setenv PATH /usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin --setenv TARGET " ..
        system.architecture .. "-pc-linux-musl --chdir /root --ro-bind " ..
        root_path .. " / --dev /dev --tmpfs /tmp " ..
        "--bind " .. cwd .. " /root --bind " .. build_path .. " /root/" .. build_suffix ..
        " /bin/lua untrusted_build.lua " .. name .. process_main_option .. " " .. stage)

    if package.variants then
        for index, _ in pairs(package.variants) do
            self.built_packages[name .. "-" .. index] = true
        end
    end
    self.built_packages[name] = true

    if stage ~= 0 then
        os.execute("umount " .. overlay_path)
    end
end

function self.unpack(path, name, variant)
    return os.execute("unsquashfs -d " ..
        path ..
        " -f pickle-linux/" ..
        name .. "/" .. base_build_path .. "/" .. tools.get_file(name, pkg(name).version, variant))
end

if stage == 0 then
    root_path = "/"
else
    lfs.mkdir("neld/" .. base_build_path)
    lfs.mkdir("neld/" .. base_build_path .. "/work")
    lfs.mkdir(mnt_path)

    lfs.mkdir(root_path)
    os.execute("squashfuse neld/" .. base_build_path .. "/work/rootfs.sqsh " .. root_path)

    lfs.mkdir(ro_path)
    lfs.mkdir(ro_path .. "/bin")
    lfs.link("../../bin/env", ro_path .. "/bin/env", true)
end

return self
