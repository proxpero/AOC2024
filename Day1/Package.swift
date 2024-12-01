// swift-tools-version: 6.0

import PackageDescription

let package = Package(
    name: "Day1",
    platforms: [.macOS(.v15)],
    targets: [
        .executableTarget(
            name: "Day1",
            resources: [.process("Input")]
        ),
    ]
)
