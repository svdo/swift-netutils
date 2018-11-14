#!/bin/sh

# For Travis:
export PATH=$HOME/swift/swift-4.2.1-RELEASE-ubuntu16.04/usr/bin:$PATH

scriptdir=$(cd $(dirname $0) && pwd)

(
    cd $(dirname $0)/App
    swift build
)
