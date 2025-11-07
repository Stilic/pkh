#!/bin/sh

not_compiled=0
total=0

for package in pickle-linux/*; do
    [ -d "$package" ] || continue
    total=$((total + 1))

    filesystem="$package/.build/filesystem"
    # Check if filesystem is missing or empty
    if [ ! -d "$filesystem" ] || [ -z "$(ls -A "$filesystem" 2>/dev/null)" ]; then
        echo "$(basename "$package")"
        not_compiled=$((not_compiled + 1))
        if [ "$1" = "fix" ]; then
            rm -rf "$package/.build"
        fi
    fi
done

echo
echo "Compiled:     $(( total - not_compiled ))"
echo "Not compiled: $not_compiled"
echo "Total:        $total"
