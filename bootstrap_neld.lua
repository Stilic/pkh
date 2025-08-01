pcall(require, "luarocks.loader")
local lfs = require "lfs"
local llby = require "lullaby"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

local config = require "neld.config"
local pkh = require "main"

os.execute("rm -rf neld/root")
lfs.mkdir("neld/root")

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
    local versions = available_packages[name]
    if versions then
        local file_name = pkh.get_file(name, versions[1])
        if not lfs.attributes(file_name) then
            llby.net.srequest(config.repository .. "/" .. repository .. "/" .. file_name).content:file(file_name)
        end
        os.execute("unsquashfs -d " .. directory .. " -f " .. file_name)
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
        else
            print("Can't find the `" .. name .. "` template!")
        end
    else
        print("Package `" .. name .. "` isn't available!")
    end
end

for name, layer in pairs(config.layers) do
    for _, package in ipairs(layer) do
        download(name, package, "../root")
    end
end

os.execute("rm -rf ../ram_root")
lfs.mkdir("../ram_root")
download("user", "busybox-static", "../ram_root")

os.remove("../vmlinuz")
lfs.link("root/lib/modules/" .. available_packages["linux"][1] .. "/vmlinuz", "../vmlinuz", true)
