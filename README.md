# pkh
The PacK Head package manager.

## Status

This is currently a **Proof Of Concept**. The goal is to demonstrate the viability of a self-hosting distribution built with a package manager written in Lua.

## Bootstraping [NELD](https://github.com/Stilic/linux-os)

You will need basic build tooling, [Lua](https://www.lua.org) (5.1 or newer), [LuaRocks](https://luarocks.org) and [Squashfs-tools](https://github.com/plougher/squashfs-tools).

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
./run.sh
```

Then, inside the VM, run `./init_dev.sh` to initialize the environment.
You can now repeat the steps if you want to build NELD inside itself.
