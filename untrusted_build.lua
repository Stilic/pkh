require "global"
local lfs = require "lfs"

local function pack(package, variant)
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
end

local name = arg[1] .. "." .. arg[2]
local package = require("pickle-linux." .. name)
if not package.name then
    local i, repository = name:match(".*%.()")
    if i ~= nil then
        repository = name:sub(1, i - 2)
        name = name:sub(i)
    end
    package.repository, package.name = repository, name
end

if arg[3] == "1" then
    local build = package.build
    if build then
        build()
        lfs.chdir("/")
    end
end
archived = pack(package)

if package.variants then
    for index, variant in pairs(package.variants) do
        lfs.chdir("/")

        variant.name = index

        local build = variant.build
        if build then
            build()
            lfs.chdir("/")
        end

        archived = pack(package, variant)
    end
end
