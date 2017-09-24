# NetUtils for Swift
![Swift Version 3](https://img.shields.io/badge/Swift-v3-yellow.svg)
![Swift Version 4](https://img.shields.io/badge/Swift-v4-yellow.svg)
[![CocoaPods Version Badge](https://img.shields.io/cocoapods/v/NetUtils.svg)](https://cocoapods.org/pods/NetUtils)
[![License Badge](https://img.shields.io/cocoapods/l/NetUtils.svg)](LICENSE.txt)
![Supported Platforms Badge](https://img.shields.io/cocoapods/p/NetUtils.svg)
[![Percentage Documented Badge](http://svdo.github.io/swift-netutils/badge.svg)](http://svdo.github.io/swift-netutils/)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat)](https://github.com/Carthage/Carthage)
[![Swift Package Manager compatible](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-brightgreen.svg)](https://github.com/apple/swift-package-manager)
[![Build Status](https://travis-ci.org/svdo/swift-netutils.svg?branch=master)](https://travis-ci.org/svdo/swift-netutils)

Swift library that simplifies getting information about your network interfaces and their properties, both for iOS and OS X.
This library is a wrapper around the BSD APIs like `getifaddrs`, to make it easy to use them from Swift.

Recommended way of integrating this library is using CocoaPods: https://cocoapods.org/pods/NetUtils.

This library works with both Swift 3 and Swift 4.

## Background Info
Some system APIs you can simply use from Swift, but others you cannot. The difference is that some are made available
as a module, and some are not. The APIs around network interfaces are not exposed as a module, which means that you
cannot use them from Swift without defining a module for them yourself. I documented this problem extensively over
here: https://ind.ie/labs/blog/using-system-headers-in-swift.

## Installation
This library can be installed via CocoaPods, Carthage and Swift Package Manager.

## Usage
This module contains only one class: `Interface`. This class represents a network interface. It has a static method
to list all interfaces, somewhat surprisingly called `allInterfaces()`. This will return an array of `Interface`
objects, which contain properties like their IP address, family, whether they are up and running, etc.

Please note that both IPv4 and IPv6 interfaces are supported.

## Development Info
Note for developers: `pod lib lint` will fail, because the prepare command is not run. After you push the tag
`pod spec lint` should pass.

## License
This project is released under the [MIT license](LICENSE.txt).
