local tools = require "tools"

local self = { BASE = "neld/" }
self.ROOTFS_CACHE = self.BASE .. ".rootfs/"
self.BUILD_CACHE = self.BASE .. ".build/"

local copied_packages = {}
function self.copy(name, path)
    local package

    local i = name:find("%.")
    if i then
        package = pkg(name:sub(1, i - 1))
    else
        package = pkg(name)
    end

    if copied_packages[name] then
        return
    else
        copied_packages[name] = true
    end

    os.execute("cp pickle-linux/" ..
        package.name .. "/.stage" .. stage .. "/" .. tools.get_file(name, package.version) .. " " .. path)

    if package.dependencies then
        for _, dep in ipairs(package.dependencies) do
            self.copy(dep.name, path)
        end
    end
end

return self
