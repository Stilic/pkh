#!/bin/sh

for package in pickle-linux/*; do
    [ -d "$package" ] || continue

    filesystem="$package/.stage4/filesystem"
    # Check if filesystem is missing or empty
    if [ ! -d "$filesystem" ] || [ -z "$(ls -A "$filesystem" 2>/dev/null)" ]; then
        echo "$(basename "$package")"
        if [ "$1" = "fix" ]; then
            rm -rf "$package/.stage4"
        fi
    fi
done
