// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "CoreAOC",
    platforms: [.macOS(.v15)],
    products: [.library(name: "CoreAOC", targets: ["CoreAOC"])],
    dependencies: [
        .package(url: "https://github.com/JohnSundell/Files", from: "4.0.0"),
        .package(url: "https://github.com/apple/swift-argument-parser", from: "1.3.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .executableTarget(
            name: "aoc",
            dependencies: [
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
                .product(name: "Files", package: "Files"),
            ]
        ),
        .target(
            name: "CoreAOC",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ]
        ),
        .testTarget(name: "CoreAOCTests", dependencies: ["CoreAOC"])
    ]
)
