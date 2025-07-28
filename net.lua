local llby = require "lullaby"

local req = llby.net.srequest("https://stilic.net")
req.content:file("index.html")