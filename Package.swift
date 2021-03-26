// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIota",
    platforms: [.iOS("13.0"),
                .macOS("10.15"),
                .tvOS("13.0"),
                .watchOS("6.0")],
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
