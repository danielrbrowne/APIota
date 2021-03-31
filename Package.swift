// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "APIota",
    products: [
        .library(
            name: "APIota",
            targets: ["APIota"])
    ],
    dependencies: [
        .package(url: "https://github.com/realm/SwiftLint",
                         .upToNextMajor(from: "0.43.1"))
    ],
    targets: [
        .target(
            name: "APIota",
            dependencies: []),
        .testTarget(
            name: "APIotaTests",
            dependencies: ["APIota"])
    ],
    swiftLanguageVersions: [.v5]
)
