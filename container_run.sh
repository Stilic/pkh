#!/bin/sh
exec podman run -it --privileged --mount type=bind,src=.,dst=/pkh local/pickle
