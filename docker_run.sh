#!/bin/sh
exec docker run -it -v .:/pkh "$@"
