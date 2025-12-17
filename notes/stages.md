each stage is built from the previous stage, except stage0 where everything is built with the host tools

# 0
build `bootstrap` + `development` packages
gcc runtimes are taken from the host

# 1
build `bootstrap` + `rootfs` + `development` packages
include all the llvm goodies

# 2
build remaining packages
