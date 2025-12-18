local self = {}

-- from https://stackoverflow.com/a/326715
function self.capture(cmd)
    local f = io.popen(cmd, "r")
    if f then
        local s = assert(f:read("*a"))
        f:close()
        s = s:gsub("^%s+", "")
            :gsub("%s+$", "")
        return s
    end
    return nil
end

self.architecture = self.capture("uname -m") or "unknown"
self.target = self.architecture .. "-linux-musl"

self.build_cores = math.max(math.floor(tonumber(self.capture("nproc")) / 1.25), 1)

function self.get_make_jobs()
    if self.build_cores == 1 then
        return ""
    else
        return " -j" .. self.build_cores
    end
end

return self
