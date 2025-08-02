#!/bin/sh

not_compiled=0
total=0

for repository in pickle-linux/*; do
    [ -d "$repository" ] || continue

    for package in "$repository"/*; do
        [ -d "$package" ] || continue
        total=$((total + 1))

        filesystem="$package/.build/filesystem"
        # Check if filesystem is missing or empty
        if [ -d "$filesystem" ] && [ ! -z "$(ls -A "$filesystem" 2>/dev/null)" ]; then
            echo -n "$(basename "$package") ($(basename "$repository"))\n"
            not_compiled=$((not_compiled + 1))
        fi
    done
done

echo "\nCompiled:     $(( total - not_compiled ))"
echo "Not compiled: $not_compiled"
echo "Total:        $total"
