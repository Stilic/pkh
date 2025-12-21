stage = 2
require "global"
pcall(require, "luarocks.loader")

local stageutils = require "stageutils"
local pkh = require "main"
pkh.init()

pkh.build("musl")
pkh.build("gcc")

stageutils.copy("musl", stageutils.ROOTFS_CACHE)
stageutils.copy("gcc.libs", stageutils.ROOTFS_CACHE)
stageutils.copy("gcc", stageutils.BUILD_CACHE)

os.execute("./pack_rootfs.sh 2")

pkh.close()
