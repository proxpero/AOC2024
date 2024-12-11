// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day1",
    platforms: [.macOS(.v15)],
    dependencies: [.package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0")],
    targets: [
        .executableTarget(
            name: "Day1",
            dependencies: ["SwiftAlgorithms"],
            resources: [.process("Input")]
        )
    ]
)
