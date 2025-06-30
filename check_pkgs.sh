#!/bin/sh

compiled=0
not_compiled=0

for pkg in pickle-linux/*; do
    fs_dir="$pkg/.build/filesystem"
    if [ ! -d "$fs_dir" ] || [ -z "$(ls -A "$fs_dir" 2>/dev/null)" ]; then
        basename "$pkg"
        ((not_compiled++))
    else
        ((compiled++))
    fi
done

total=$((compiled + not_compiled))

echo
echo "Summary:"
echo "Compiled packages:     $compiled"
echo "Not compiled packages: $not_compiled"
echo "Total packages:        $total"
