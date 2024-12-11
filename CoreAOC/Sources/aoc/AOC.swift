import ArgumentParser
import Files
import Foundation

@main
struct AOC: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Tools for Advent of Code",
        subcommands: [Init.self]
    )
}

struct Init: ParsableCommand {
    @Argument var day: Int

    func run() throws {
        let folder = try Folder.current.createSubfolder(named: "Day\(day)")
        try folder.createFile(named: "Package.swift", contents: package())
        let sources = try folder.createSubfolder(named: "Sources")
        try sources.createFile(named: "main.swift", contents: main())
        try sources.createFile(named: "Input")
    }

    func package() throws -> Data? {
        """
        // swift-tools-version: 6.0
        
        import PackageDescription
        
        let package = Package(
            name: "Day\(day)",
            platforms: [.macOS(.v15)],
            dependencies: [
                .package(url: "https://github.com/apple/swift-algorithms.git", .upToNextMajor(from: "1.2.0")),
                .package(path: "../CoreAOC")
            ],
            targets: [
                .executableTarget(
                    name: "Day\(day)",
                    dependencies: [
                        .product(name: "Algorithms", package: "swift-algorithms"),
                        .product(name: "CoreAOC", package: "CoreAOC")
                    ],
                    resources: [.process("Input")]
                )
            ]
        )
        """.data(using: .utf8)
    }

    func main() throws -> Data? {
        #"""
        import Algorithms
        import CoreAOC
        import Foundation
        
        var start = CFAbsoluteTimeGetCurrent()
        
        var input = try Bundle.module.url(forResource: "Input", withExtension: nil).flatMap {
            try String(contentsOf: $0, encoding: .utf8)
        }!
        
        // MARK: Parsing
        
        print("parsing: \(CFAbsoluteTimeGetCurrent() - start)")
        start = CFAbsoluteTimeGetCurrent()
        
        // MARK: Part 1
        
        let p1 = 0
        
        print("part 1: \(p1), \(CFAbsoluteTimeGetCurrent() - start)")
        
        // MARK: Part 2
        
        let p2 = 0
        
        print("part 2: \(p2), \(CFAbsoluteTimeGetCurrent() - start)")
        """#.data(using: .utf8)
    }
}
