import Algorithms
import Foundation

var start = CFAbsoluteTimeGetCurrent()

let input = try Bundle.module.url(forResource: "Input", withExtension: nil).flatMap {
    try String(contentsOf: $0, encoding: .utf8)
}!

// MARK: Parsing

struct Report {
    var levels: [Int]
}

extension Report {
    init(line: Substring) {
        self.levels = line.split(separator: " ").map { Int($0)! }
    }
}

let reports = input.split(separator: "\n")
    .map(Report.init)

print("parsing: \(CFAbsoluteTimeGetCurrent() - start)")
start = CFAbsoluteTimeGetCurrent()

// MARK: Part 1

extension Report {
    var isSafe: Bool {
        (levels.isSortedAscending || levels.isSortedDescending)
        && levels.adjacentPairs().allSatisfy { 1...3 ~= abs($0.0 - $0.1) }
    }
}

let p1 = reports.count(where: { $0.isSafe })

print("part 1: \(p1), \(CFAbsoluteTimeGetCurrent() - start)")
start = CFAbsoluteTimeGetCurrent()

// MARK: Part 2

extension Report {
    var isSafeUsingDampener: Bool {
        if isSafe { return true }

        for i in levels.indices {
            var temp = self
            temp.levels.remove(at: i)
            if temp.isSafe { return true }
        }

        return false
    }
}

let p2 = reports.count(where: { $0.isSafeUsingDampener })

print("part 2: \(p2), \(CFAbsoluteTimeGetCurrent() - start)")

extension Collection where Element: Comparable {
    var isSortedAscending: Bool {
        adjacentPairs().allSatisfy { $0 < $1 }
    }

    var isSortedDescending: Bool {
        adjacentPairs().allSatisfy { $0 > $1 }
    }
}
