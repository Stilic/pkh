# pkh
The PacK Head package manager.

## Status

This is currently a **Proof Of Concept**. The goal is to demonstrate the viability of a self-hosting distribution built with a package manager written in Lua.

## Bootstraping Pickle Linux

You will need basic build tooling, [Lua](https://www.lua.org) (5.1 or newer), [LuaRocks](https://luarocks.org), [Squashfs-tools](https://github.com/plougher/squashfs-tools) and [QEMU](https://www.qemu.org).

```
# Install Lua dependencies
luarocks install luafilesystem
# Build the core packages
lua bootstrap_neld.lua

# Go inside the `neld` folder
cd neld
# Build the ramdisk
./build_ramdisk.sh
# Build the disk
sudo ./build_disk.sh

# Run the result in a VM
sudo ./run.sh
```

To login, type `root` and press Enter.

Then, you can repeat the steps if you want to build it again inside itself.
