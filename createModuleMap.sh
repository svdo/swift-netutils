#!/bin/sh

modulesDirectory=$DERIVED_FILES_DIR/modules
modulesMap=$modulesDirectory/module.modulemap
modulesMapTemp=$modulesDirectory/module.modulemap.tmp

mkdir -p "$modulesDirectory"

cat > "$modulesMapTemp" << MAP
module ifaddrs [system] [extern_c] {
    header "$SDKROOT/usr/include/ifaddrs.h"
    export *
}

MAP

diff "$modulesMapTemp" "$modulesMap" >/dev/null 2>/dev/null
if [[ $? != 0 ]] ; then
	mv "$modulesMapTemp" "$modulesMap"
else
	rm "$modulesMapTemp"
fi
