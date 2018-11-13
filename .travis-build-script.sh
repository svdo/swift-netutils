#!/bin/sh


if [ ${TRAVIS_OS_NAME} = "osx" ]; then

  if [ ${XCODE} = "10" ]; then
    set -o pipefail
    xcodebuild \
      -enableAddressSanitizer NO \
      -project NetUtils.xcodeproj \
      -scheme NetUtils \
      test \
      -sdk iphonesimulator \
      -destination "platform=iOS Simulator,name=iPhone 6,OS=${IOS_VERSION}" | xcpretty
  fi

elif [ ${TRAVIS_OS_NAME} = "linux" ]; then

    export PATH=$HOME/swift/swift-4.2.1-RELEASE-ubuntu16.04/usr/bin:$PATH
    swift test

fi
