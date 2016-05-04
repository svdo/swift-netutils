#!/bin/sh

version=`cat NetUtils.podspec.json|grep "version"|cut -d ':' -f 2|sed "s|.*\"\(.*\)\".*|\1|"`

jazzy \
  --clean \
  --author "Stefan van den Oord" \
  --author_url https://github.com/svdo \
  --github_url https://github.com/svdo/swift-netutils \
  --github-file-prefix https://github.com/svdo/swift-netutils/tree/$version \
  --module-version $version \
  --module NetUtils \
  --readme README.md \
  --copyright "Copyright © 2015 [Stefan van den Oord](https://github.com/svdo). All rights reserved" \
  --output docs
