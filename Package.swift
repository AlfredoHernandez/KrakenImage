// swift-tools-version: 5.7
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "KrakenImage",
    platforms: [
        .iOS(.v13),
    ],
    products: [
        .library(name: "KrakenImage", targets: ["KrakenImage"]),
    ],
    dependencies: [
        .package(url: "https://github.com/AlfredoHernandez/KrakenNetwork.git", branch: "main"),
    ],
    targets: [
        .target(name: "KrakenImage", dependencies: [
            .product(name: "KrakenNetwork", package: "KrakenNetwork"),
        ]),
        .testTarget(name: "KrakenImageTests", dependencies: ["KrakenImage"]),
    ]
)
