#!/bin/sh
export PATH=/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin
export ARCH=x86_64
luarocks install luafilesystem
git clone https://github.com/Stilic/pkh.git
cd pkh
lua bootstrap_neld.lua
