import Algorithms
import CoreAOC
import Foundation
import RegexBuilder

var start = CFAbsoluteTimeGetCurrent()

var input = try Bundle.module.url(forResource: "Input", withExtension: nil).flatMap {
    try String(contentsOf: $0, encoding: .utf8)
}!

// MARK: Parsing

print("parsing: \(CFAbsoluteTimeGetCurrent() - start)")
start = CFAbsoluteTimeGetCurrent()

// MARK: Part 1

let regex1 = /mul\((\d{1,3}),(\d{1,3})\)/
let matches = input.matches(of: regex1)

let p1 = matches.map { Int($0.output.1)! * Int($0.output.2)! }
    .reduce(0, +)

print("part 1: \(p1), \(CFAbsoluteTimeGetCurrent() - start)")

// MARK: Part 2

let regex2 = Regex {
    ChoiceOf {
        /(mul)\((\d{1,3}),(\d{1,3})\)/
        /(do)\(\)/
        /(don't)\(\)/
    }
}

var enabled = true
var p2 = 0

for match in input.matches(of: regex2) {
    switch match.output.1 ?? match.output.4 ?? match.output.5 {
    case "mul":
        guard enabled else { continue }
        p2 += Int(match.output.2!)! * Int(match.output.3!)!
    case "do":
        enabled = true
    case "don't":
        enabled = false
    default:
        continue
    }
}

print("part 2: \(p2), \(CFAbsoluteTimeGetCurrent() - start)")
