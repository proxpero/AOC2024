// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day2",
    platforms: [.macOS(.v15)],
    dependencies: [.package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0"))],
    targets: [
        .executableTarget(
            name: "Day2",
            dependencies: [.product(name: "Algorithms", package: "swift-algorithms")],
            resources: [.process("Input")]
        )
    ]
)
