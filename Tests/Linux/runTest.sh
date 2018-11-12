#!/bin/sh

scriptdir=$(cd $(dirname $0) && pwd)

(
    cd $(dirname $0)/App
    swift build
)
