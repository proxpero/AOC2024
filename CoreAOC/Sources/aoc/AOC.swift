import ArgumentParser
import Files
import Foundation
import ShellOut

@main
struct AOC: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Tools for Advent of Code",
        subcommands: [Init.self]
    )
}

struct Init: ParsableCommand {
    @Argument var day: Int
    @Option var year: Int?

    @Option(help: "The adventofcode.com \"session\" cookie.")
    var sessionCookie: String?

    struct Configuration: Codable {
        var sessionCookie: String?
    }

    func run() throws {
        print("Creating a package for Day\(day) \(defaultYear)")
        let folder = try Folder.current.createSubfolder(named: "Day\(day)")
        let package = try createPackage(in: folder)
        let sources = try folder.createSubfolder(named: "Sources")
        try createMain(in: sources)
        try createInput(in: sources)
        print("Done.")

        print("Quitting Xcode.")
        try shellOut(to: "osascript -e 'quit app \"Xcode\"'")
        try shellOut(to: "open -g \(package.path)")
    }

    private var configFile: File {
        let filename = ".config"
        if !Folder.current.containsFile(named: filename) {
            do {
                let config = try Folder.current.createFile(named: filename)
                return config
            } catch {
                fatalError("Could not create configuration file.")
            }
        }

        do {
            return try Folder.current.file(named: filename)
        } catch {
            fatalError("Could not find configuration file.")
        }
    }

    private var config: Configuration {
        let data = try! configFile.read()
        var config: Configuration! = try? JSONDecoder().decode(Configuration.self, from: data)
        if config == nil {
            config = Configuration()
            let data = try! JSONEncoder().encode(config)
            try! configFile.write(data)
        }
        return config
    }

    private func updateSessionCookieIfAvailable() throws {
        var config = config
        if let sessionCookie {
            config.sessionCookie = sessionCookie
            let data = try JSONEncoder().encode(config)
            try configFile.write(data)
        }

        guard let sessionCookie = sessionCookie ?? config.sessionCookie else {
            print("No session cookie available.")
            return
        }

        let cookie = HTTPCookie(properties: [
            .domain: ".adventofcode.com",
            .path: "/",
            .secure: "true",
            .name: "session",
            .value: sessionCookie
        ])!

        HTTPCookieStorage.shared.setCookie(cookie)
    }

    private var defaultYear: Int {
        if let year { return year }

        let month = Calendar.current.component(.month, from: Date())
        var year = Calendar.current.component(.year, from: Date())
        if month < 12 {
            year -= 1
        }

        return year
    }

    private func fetchInput() -> Data? {
        try! updateSessionCookieIfAvailable()
        let url = URL(string: "https://adventofcode.com/\(defaultYear)/day/\(day)/input")!
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            fatalError("Download failed")
        }

        if String(decoding: data, as: UTF8.self).contains("Please log in to get your puzzle input.") {
            fatalError("Authentication failed")
        }

        return data
    }

    @discardableResult
    private func createPackage(in folder: Folder) throws -> File {
        let url = Bundle.module.url(forResource: "Package", withExtension: "txt")!
        var data = try Data(contentsOf: url)
        let contents = String(decoding: data, as: UTF8.self)
            .replacingOccurrences(of: "{{day}}", with: "\(day)")
        data = Data(contents.utf8)
        let file = try folder.createFile(named: "Package.swift", contents: data)
        return file
    }

    private func createMain(in folder: Folder) throws {
        let url = Bundle.module.url(forResource: "Day", withExtension: "txt")!
        let data = try Data(contentsOf: url)
        try folder.createFile(named: "main.swift", contents: data)
    }

    private func createInput(in folder: Folder) throws {
        try! updateSessionCookieIfAvailable()
        let url = URL(string: "https://adventofcode.com/\(defaultYear)/day/\(day)/input")!
        let data: Data
        do {
            data = try Data(contentsOf: url)
        } catch {
            fatalError("Download failed")
        }

        if String(decoding: data, as: UTF8.self).contains("Please log in to get your puzzle input.") {
            fatalError("Authentication failed")
        }

        try folder.createFile(named: "Input", contents: data)
    }

}
