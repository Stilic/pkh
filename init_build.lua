hostfs = true
require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"

pkh.build("binutils")
pkh.build("gcc")

pkh.close()
