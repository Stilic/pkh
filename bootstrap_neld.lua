require "luarocks.loader"
local lfs = require "lfs"
local pkh = require "main"

local function add(name)
    if not lfs.attributes("pkgs/" .. name .. "/.build/" .. require("pkgs." .. name).version .. ".sqsh") then
        pkh.build(name)
    end
    pkh.unpack(name, "root")
end

os.execute("rm -rf root")
lfs.mkdir("root")
add("busybox")
