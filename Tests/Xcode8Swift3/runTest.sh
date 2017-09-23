#!/bin/sh

set -o pipefail

xcodeVersion=$(xcrun xcodebuild -version)
if ( ! ( echo ${xcodeVersion} | grep "Xcode 8" > /dev/null 2>&1 ) ); then
    echo "Expected Xcode 8.x, got "$(xcrun xcodebuild -version|grep "Xcode ")
fi

(
    cd $(dirname $0)/App
    pod install
    xcrun xcodebuild -workspace App.xcworkspace -scheme App | xcpretty
)
