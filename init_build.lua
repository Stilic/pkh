hostfs = true
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"

pkh.build("llvm")

pkh.close()
