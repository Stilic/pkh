local self = {}

-- from https://stackoverflow.com/a/326715
function self.capture(cmd)
    local f = assert(io.popen(cmd, "r"))
    local s = assert(f:read("*a"))
    f:close()
    s = s:gsub("^%s+", "")
        :gsub("%s+$", "")
        :gsub("[\n\r]+", " ")
    return s
end

self.buildCores = math.floor(tonumber(self.capture("nproc")) / 1.5)

return self
