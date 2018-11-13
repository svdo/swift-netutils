#!/bin/sh

set -o pipefail

if [ ${XCODE} = "10" ]; then
  xcodebuild \
    -enableAddressSanitizer NO \
    -project NetUtils.xcodeproj \
    -scheme NetUtils \
    test \
    -sdk iphonesimulator \
    -destination "platform=iOS Simulator,name=iPhone 6,OS=${IOS_VERSION}"
fi
