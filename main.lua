require "luarocks.loader"
local lfs = require "lfs"
local packages = { busybox = require "pkgs.busybox" }

print(math.floor(tonumber(io.popen('nproc', 'r'):read('*l')) / 1.5))

local function rmdirf(dir)
    for file in lfs.dir(dir) do
        local file_path = dir .. '/' .. file
        if file ~= "." and file ~= ".." then
            if lfs.attributes(file_path, 'mode') == 'file' then
                os.remove(file_path)
            elseif lfs.attributes(file_path, 'mode') == 'directory' then
                rmdirf(file_path)
            end
        end
    end
    lfs.rmdir(dir)
end

local function build_package(name)
    local package = packages[name]

    rmdirf("temp")
    lfs.mkdir("temp")
    lfs.chdir("temp")

    if type(package.source) == "string" then
        os.execute("curl -o archive " .. package.source)
        lfs.mkdir("source")
        os.execute("tar -xf archive --strip-components=1 -C source")
    end
end

-- build_package("busybox")
