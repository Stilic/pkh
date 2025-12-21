each stage is built from the previous stage, except stage0 where everything is built with the host tools

# 1
build `bootstrap` + `development` packages
gcc runtimes are taken from the host

# 2
build a proper gcc toolchain

# 3
build `bootstrap` + `development` packages
provide a clean build environment

# 4
build `bootstrap` + `rootfs` + `development` packages
