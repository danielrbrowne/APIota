// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIota",
    platforms: [.iOS(.v13),
                .macOS(.v10_15),
                .tvOS(.v13)],
    products: [
        .library(
            name: "APIota",
            targets: ["APIota"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "APIota",
            dependencies: []),
        .testTarget(
            name: "APIotaTests",
            dependencies: ["APIota"]),
    ],
    swiftLanguageVersions: [.v5]
)
