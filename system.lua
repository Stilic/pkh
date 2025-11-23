local self = {}

-- from https://stackoverflow.com/a/326715
function self.capture(cmd)
    local f = assert(io.popen(cmd, "r"))
    local s = assert(f:read("*a"))
    f:close()
    s = s:gsub("^%s+", "")
        :gsub("%s+$", "")
    return s
end

-- self.build_cores = math.max(math.floor(tonumber(self.capture("nproc")) / 1.5), 1)
self.build_cores = 8

function self.get_make_jobs()
    if self.build_cores == 1 then
        return ""
    else
        return " -j " .. self.build_cores
    end
end

return self
