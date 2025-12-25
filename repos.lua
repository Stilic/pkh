pcall(require, "luarocks.loader")
local system = require("system")

local lfs = require "lfs"
local tools = require "tools"
local config = require "neld.config"

local self = { available_packages = {} }

function self.init()
    self.available_packages = {}
    for line in system.capture("curl -sL " .. config.binhost .. "/packages/available.txt"):gmatch("[^\r\n]+") do
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

        local available_versions = self.available_packages[name]
        if not available_versions then
            available_versions = {}
            self.available_packages[name] = available_versions
        end
        table.insert(available_versions, version)
    end
end

local installed_packages = {}
function self.download(name, directory)
    if installed_packages[name] then
        return
    end

    print("INSTALLING: " .. name)

    local versions = self.available_packages[name]
    if versions then
        local file_name = tools.get_file(name, versions[1])
        if not lfs.attributes(file_name) then
            local success = os.execute("curl -sSLo " .. file_name .. " " .. config.binhost .. "/packages/" .. file_name)
            if not success then
                print("ERROR: Package `" .. name .. "` isn't available!")
                return
            end
        end
        if directory then
            os.execute("unsquashfs -d " .. directory .. " -f " .. file_name)
        end
        installed_packages[name] = true

        local package, i = name:find("%.")
        if i then
            package = pkg(name:sub(1, i - 1))
        else
            package = pkg(name)
        end
        if package.dependencies then
            for _, dep in ipairs(package.dependencies) do
                self.download(dep.name, directory)
            end
        end
    else
        print("ERROR: Package `" .. name .. "` isn't available!")
    end
end

return self
