require "luarocks.loader"
local lfs = require "lfs"
local pkh = require "main"

local function add(name)
    if not lfs.attributes("pkgs/" .. name .. "/.build/" .. require("pkgs." .. name).version .. ".sqsh") then
        pkh.build(name)
    end
    pkh.unpack(name, "neld")
end

os.execute("rm -rf neld")
lfs.mkdir("neld")

add("busybox")
