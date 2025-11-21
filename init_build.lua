require "global"
pcall(require, "luarocks.loader")

local pkh = require "main"

pkh.build("gcc")

pkh.close()
