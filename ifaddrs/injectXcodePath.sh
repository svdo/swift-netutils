#!/bin/sh

set -x

defaultXcodePath="/Applications/Xcode.app/Contents/Developer"
realXcodePath="`xcode-select -p`"

fatal() {
    echo "[fatal] $1" 1>&2
    exit 1
}

absPath() {
    case "$1" in
        /*)
            printf "%s\n" "$1"
            ;;
        *)
            printf "%s\n" "$PWD/$1"
            ;;
    esac;
}

scriptDir="`dirname $0`"
scriptName="`basename $0`"
absScriptDir="`cd $scriptDir; pwd`"

main() {
    xcodeMajor=$(xcrun xcodebuild -version|grep -E "Xcode \d+\.\d+(\.\d+)?"|cut -d ' ' -f 2|cut -d '.' -f 1)
    set -i xcodeMajor
    if [ ${xcodeMajor} -lt 9 ]; then
        echo "Xcode prior to 9: ifaddrs module maps needed."
        for f in `find ${absScriptDir} -name module.modulemap`; do
            cat ${f} | sed "s,${defaultXcodePath},${realXcodePath},g" > ${f}.new || fatal "Failed to update modulemap ${f}"
            mv ${f}.new ${f} || fatal "Failed to replace modulemap ${f}"
        done
    else
        echo "Xcode 9 and above: ifaddrs module maps not needed."
        cd $(dirname $0)
        rm -f */module.modulemap
    fi

}

main $*
