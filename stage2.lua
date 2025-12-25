stage = 2
require "global"
pcall(require, "luarocks.loader")

local repos = require "repos"
local pkh = require "main"

pkh.build("gcc")
pkh.close()

repos.copy("gcc", repos.BUILD_CACHE)
repos.copy("gcc.libs", repos.ROOTFS_CACHE)

os.execute("./pack_rootfs.sh 2")
