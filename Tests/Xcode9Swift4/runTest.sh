#!/bin/sh

set -o pipefail

xcodeVersion=$(xcrun xcodebuild -version)
if ( ! ( echo ${xcodeVersion} | grep "Xcode 9" > /dev/null 2>&1 ) ); then
    echo "Expected Xcode 9.x, got "$(xcrun xcodebuild -version|grep "Xcode ")
    exit 1
fi

(
    cd $(dirname $0)/App
    pod install
    xcrun xcodebuild -workspace App.xcworkspace -scheme App | xcpretty
)
