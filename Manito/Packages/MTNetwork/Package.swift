// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "MTNetwork",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "MTNetwork",
            targets: ["MTNetwork"]),
    ],
    dependencies: [ ],
    targets: [
        .target(
            name: "MTNetwork",
            dependencies: []),
        .testTarget(
            name: "MTNetworkTests",
            dependencies: ["MTNetwork"]),
    ]
)
