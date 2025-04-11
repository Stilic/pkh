# pkh
The PacK Head package manager.

**Currently W.I.P.**

# Bootstraping [NELD](https://github.com/Stilic/linux-os)

You will need basic build tooling, [Lua](https://www.lua.org) (5.1 or newer), [LuaRocks](https://luarocks.org) and [Squashfs-tools](https://github.com/plougher/squashfs-tools).

```
# Install Lua dependencies
luarocks install luafilesystem
# Compile the base packages and create a rootfs
lua bootstrap_neld.lua
```
