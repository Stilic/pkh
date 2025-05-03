require "luarocks.loader"
local lfs = require "lfs"
local pkh = require "main"
local system = require "system"

local BINARY_HOST = "https://pickle.stilic.net/packages"
local base_overlay = {
    -- base
    "linux",

    "musl",
    "musl-fts",
    "musl-obstack",
    "argp",
    "readline",
    "curses",

    -- rsync deps
    "attr",
    "acl",
    "popt",
    --

    -- util-linux deps
    "sqlite3",
    --

    "toybox",
    "file",
    "rsync",
    "diffutils",
    "gawk",
    "sed",
    "cpio",
    "e2fsprogs",
    "util-linux",
    "perl",
    "python",

    "pcre2",
    "grep",

    -- nano
    "gperf",
    "libseccomp",
    "nano",

    "libmd",
    "dhcpcd",
    "ifupdown-ng",

    "libxcrypt",
    "bash",

    "xz",

    "gmp",
    "mpfr",
    "mpc",
    "binutils",
    "gcc",

    -- autotools
    "libtool",
    "automake",
    "autoconf",
    --

    "make",
    "pkgconf",

    "cmake",

    -- curl
    "libunistring",
    "libidn2",
    "libpsl",
    "openssl",
    "nghttp2",
    "zlib",
    "zstd",
    "brotli",
    "curl",

    -- git
    "expat",
    "libiconv",
    "libxml2",
    "git",

    "gettext",
    "m4",

    -- linux build dependencies
    "bzip2",
    "flex",
    "bison",
    "elfutils",
    "dosfstools",

    -- package manager
    "unzip",
    "zip",
    "lzo",
    "squashfs-tools",
    "lua",
    "luarocks",
}

os.execute("rm -rf neld/root")
lfs.mkdir("neld/root")

local og_path = lfs.currentdir()

lfs.mkdir("neld/.cache")
lfs.chdir("neld/.cache")

local available_packages = {}
for line in system.capture("curl -L " .. BINARY_HOST .. "/available.txt"):gmatch("[^\r\n]+") do
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

local function download(name, directory)
    local versions = available_packages[name]
    if versions then
        local file_name = pkh.get_file(name, versions[1])
        if not lfs.attributes(file_name) then
            os.execute("curl -LOJ " .. BINARY_HOST .. "/" .. file_name)
        end
        os.execute("unsquashfs -d " .. directory .. " -f " .. file_name)
    else
        print("Package `" .. name .. "` isn't available!")
    end
end

for _, name in ipairs(base_overlay) do
    download(name, "../root")
end

os.execute("rm -rf ../ram_root")
lfs.mkdir("../ram_root")
download("busybox-static", "../ram_root")

os.remove("../vmlinuz")
os.execute("ln -s root/lib/modules/" .. available_packages["linux"][1] .. "/vmlinuz ..")
