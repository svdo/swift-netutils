#!/bin/sh

set -o pipefail

scriptdir=$(cd $(dirname $0) && pwd)
echo "Running Pod test for $(basename ${scriptdir})."

xcodeVersion=$(xcrun xcodebuild -version)
if ( ! ( echo ${xcodeVersion} | grep "Xcode 10" > /dev/null 2>&1 ) ); then
    echo "Expected Xcode 10.x, got "$(xcrun xcodebuild -version|grep "Xcode ")
    exit 1
fi

(
    cd $(dirname $0)/App
    pod install
    xcrun xcodebuild -workspace App.xcworkspace -scheme App -sdk iphonesimulator | xcpretty
)
