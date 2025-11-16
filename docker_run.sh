#!/bin/sh
exec docker run -it --privileged --mount type=bind,src=.,dst=/pkh "$@"
