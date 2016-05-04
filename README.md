# NetUtils for Swift [![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)

Swift library that simplifies getting information about your network interfaces and their properties, both for iOS and OS X.
This library is a wrapper around the BSD APIs like getifaddrs, to make it easy to use them from Swift.

Recommended way of integrating this library is using CocoaPods: https://cocoapods.org/pods/NetUtils.

Note for developers: `pod lib lint` will fail, because the prepare command is not run. After you push the tag
`pod spec lint` should pass.