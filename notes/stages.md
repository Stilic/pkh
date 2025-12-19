each stage is built from the previous stage, except stage0 where everything is built with the host tools

# 1
build `bootstrap` + `development` packages
gcc runtimes are taken from the host

# 2
build a proper gcc toolchain

# 3
build `bootstrap` + `rootfs` + `development` packages with the gcc toolchain
