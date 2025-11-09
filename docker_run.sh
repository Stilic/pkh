#!/bin/sh
exec docker run -it -v .:/pkh --cap-add SYS_ADMIN --device /dev/fuse:/dev/fuse --security-opt apparmor:unconfined "$@"
