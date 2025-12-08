# PKH

The PacK Head package manager.

## Status

This is currently a **Work In Progress**. The goal is to demonstrate the viability of a self-hosting distribution built with a package manager written in Lua.

## Pickle Linux

### Bootstrap

You will need Docker.
```
# Set up the builder image
./docker_build.sh
# Run it
./docker_run.sh
```

The following steps have to be done inside the Docker container:
```
# Move to the source directory
cd /pkh
# Set up the bootstrap environment
lua bootstrap_neld.lua
# Build all the packages
lua build.lua
```

### Run

You will need QEMU.

```
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
