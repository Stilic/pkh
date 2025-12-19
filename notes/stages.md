each stage is built from the previous stage, except stage0 where everything is built with the host tools

# 1
build `bootstrap` + `development` packages
then build an intermediate llvm toolchain
gcc runtimes are taken from the host

# 2
build an intermediate gcc toolchain

# 3
build `bootstrap` + `rootfs` packages with the gcc toolchain
