pcall(require, "luarocks.loader")
local lfs = require "lfs"
local llby = require "lullaby"

local current_directory = lfs.currentdir()
package.path = package.path
    .. ";" .. current_directory .. "/?.lua"
    .. ";" .. current_directory .. "/?/init.lua"

local pkh = require "main"

local BINARY_HOST = "https://pickle.stilic.net/packages"
local main_layer = {
    "linux",

    "musl",
    "musl-fts",
    "musl-obstack",
    "argp",

    "sqlite3",

    "libxcrypt",
    "toybox",
    "file",
    "diffutils",
    "gawk",
    "sed",
    "util-linux",

    "grep",

    "libmd",
    "dhcpcd",
    "ifupdown-ng",

    "bash",

    "xz",
    "zlib",
    "gettext",

    "unzip",
    "zip",
    "bzip2",

    "libcap",
    "udev",

    "linux-pam",
    "shadow",

    "dbus",
    "turnstile",

    "sysklogd",
    "dinit",

    -- for git
    "libxml2",

    -- TODO: package pkh itself
    "lzo",
    "squashfs-tools",
    "lua",
    "luarocks",
}
local user_layer = {
    -- TODO: move back to main repo
    "libunistring",
    "libidn2",
    "libpsl",
    "openssl",
    "nghttp2",
    "zstd",
    "brotli",
    "curl",
    --

    "curses",
    "rsync",
    "cpio",
    "python",

    "pcre2",

    "flex",
    "binutils",
    "make",
    "pkgconf",
    "m4",
    "gcc",

    -- autotools
    "libtool",
    "automake",
    "autoconf",
    --

    -- TODO: make these optional
    -- "e2fsprogs",
    -- "gperf",
    -- "libseccomp",
    "nano",

    "git",

    -- uwu
    "cottonfetch"
}

os.execute("rm -rf neld/root")
lfs.mkdir("neld/root")

lfs.mkdir("neld/.cache")
lfs.chdir("neld/.cache")

local available_packages = {}
for line in llby.net.srequest(BINARY_HOST .. "/available.txt").content:read():gmatch("[^\r\n]+") do
    local i, name, version = 1

    for part in line:gmatch("([^,]+)") do
        if i == 3 then
            break
        end
        if i == 1 then
            name = part
        else
            version = part
        end
        i = i + 1
    end

    local available_versions = available_packages[name]
    if not available_versions then
        available_versions = {}
        available_packages[name] = available_versions
    end
    table.insert(available_versions, version)
end

local installed_packages = {}
local function download(repository, name, directory)
    local versions = available_packages[name]
    if versions then
        local file_name = pkh.get_file(name, versions[1])
        if not lfs.attributes(file_name) then
            llby.net.srequest(BINARY_HOST .. "/" .. repository .. "/" .. file_name).content:file(file_name)
        end
        os.execute("unsquashfs -d " .. directory .. " -f " .. file_name)
        installed_packages[name] = true

        local package = pkg(repository .. "." .. name)
        if package then
            if package.dependencies then
                for _, dep in ipairs(package.dependencies) do
                    local name = dep.name
                    if not installed_packages[name] then
                        download(dep.repository, name, directory)
                    end
                end
            end
        else
            print("Can't find the `" .. name .. "` template!")
        end
    else
        print("Package `" .. name .. "` isn't available!")
    end
end

for _, name in ipairs(main_layer) do
    download("main", name, "../root")
end
for _, name in ipairs(user_layer) do
    download("user", name, "../root")
end

os.execute("rm -rf ../ram_root")
lfs.mkdir("../ram_root")
download("user", "busybox-static", "../ram_root")

os.remove("../vmlinuz")
os.execute("ln -s root/lib/modules/" .. available_packages["linux"][1] .. "/vmlinuz ..")
