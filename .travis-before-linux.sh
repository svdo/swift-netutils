#!/bin/sh

cd $HOME
mkdir -p swift
cd swift
test -d swift-4.2.1-RELEASE-ubuntu16.04 && exit 0

wget https://swift.org/builds/swift-4.2.1-release/ubuntu1604/swift-4.2.1-RELEASE/swift-4.2.1-RELEASE-ubuntu16.04.tar.gz
tar xzvf swift-4.2.1-RELEASE-ubuntu16.04.tar.gz

