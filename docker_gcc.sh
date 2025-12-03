#!/bin/sh
BASE="/usr/lib/"
LIBS="libasan libatomic libgcc_s libgomp libitm libquadmath libstdc++ libtsan libubsan libssp"

cp -r -P ${BASE}gcc .

for lib in $LIBS; do
    find ${BASE} -maxdepth 1 \( -type f -o -type l \) -name "${lib}*" ! -name "*.la" -exec cp -P {} . \;
done
