pcall(require, "luarocks.loader")
local lfs = require "lfs"
local llby = require "lullaby"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

local config = require "neld.config"
local pkh = require "main"

lfs.mkdir("neld/.cache")
lfs.chdir("neld/.cache")

local available_packages = {}
for line in llby.net.srequest(config.repository .. "/available.txt").content:read():gmatch("[^\r\n]+") do
    local i, name, version = 1

    for part in line:gmatch("([^,]+)") do
        if i == 3 then
            break
        end
        if i == 1 then
            name = part
        else
            version = part
        end
        i = i + 1
    end

    local available_versions = available_packages[name]
    if not available_versions then
        available_versions = {}
        available_packages[name] = available_versions
    end
    table.insert(available_versions, version)
end

local installed_packages = {}
local function download(repository, name, directory)
    print("INSTALLING: " .. name)

    local versions = available_packages[name]
    if versions then
        local file_name = pkh.get_file(name, versions[1])
        if not lfs.attributes(file_name) then
            llby.net.srequest(config.repository .. "/" .. repository .. "/" .. file_name).content:file(file_name)
        end
        if directory then
            os.execute("unsquashfs -d " .. directory .. " -f " .. file_name)
        end
        installed_packages[name] = true

        local package = pkg(repository .. "." .. name)
        if package then
            if package.dependencies then
                for _, dep in ipairs(package.dependencies) do
                    local name = dep.name
                    if not installed_packages[name] then
                        download(dep.repository, name, directory)
                    end
                end
            end
            if package.dev_dependencies then
                for _, dep in ipairs(package.dev_dependencies) do
                    local name = dep.name
                    if not installed_packages[name] then
                        download(dep.repository, name, directory)
                    end
                end
            end
        else
            print("ERROR: Can't find the `" .. name .. "` template!")
        end
    else
        print("ERROR: Package `" .. name .. "` isn't available!")
    end
end

for name, layer in pairs(config.layers) do
    for _, package in ipairs(layer) do
        download(name, package)
    end
end

download("main", "base")

os.execute("rm -rf neld/linux")
lfs.mkdir("neld/linux")
download("main", "linux", "../linux")

os.execute("rm -rf ../ram_root")
lfs.mkdir("../ram_root")
download("user", "busybox-static", "../ram_root")

os.remove("../vmlinuz")
lfs.link("linux/lib/modules/" .. available_packages["linux"][1] .. "/vmlinuz", "../vmlinuz", true)
