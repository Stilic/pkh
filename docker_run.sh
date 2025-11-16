#!/bin/sh
exec docker run -it --mount type=bind,src=.,dst=/pkh --cap-add SYS_ADMIN --device /dev/fuse:/dev/fuse --security-opt apparmor:unconfined --security-opt seccomp=docker-seccomp.json "$@"
