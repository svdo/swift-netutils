// swift-tools-version:4.0

import PackageDescription

let package = Package(
    name: "NetUtils",
    products: [
        .library(
            name: "NetUtils",
            targets: ["NetUtils"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "NetUtils",
            dependencies: [],
            path: "NetUtils"),
        .testTarget(
            name: "NetUtilsTests",
            dependencies: ["NetUtils"],
            path: "NetUtilsTests")
    ]
)
