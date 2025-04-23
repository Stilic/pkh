#!/bin/sh
for pkg in pkgs/*; do
    fs_dir="$pkg/.build/filesystem"
    if [ ! -d "$fs_dir" ] || [ -z "$(ls -A "$fs_dir" 2>/dev/null)" ]; then
        echo "$(basename "$pkg")"
    fi
done
