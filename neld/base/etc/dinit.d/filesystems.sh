#!/bin/sh
export PATH=/usr/bin:/usr/sbin:/bin:/sbin

set -e

if [ "$1" != "stop" ]; then

  # TODO: mount swap the right way
  echo "Mounting auxillary filesystems...."
  # swapon /swapfile
  mount -avt noproc,nonfs

fi;
