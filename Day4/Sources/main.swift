import Algorithms
import CoreAOC
import Foundation

var start = CFAbsoluteTimeGetCurrent()

var input = try Bundle.module.url(forResource: "Input", withExtension: nil).flatMap {
    try String(contentsOf: $0, encoding: .utf8)
}!

let sample = """
.M.S......
..A..MSMS.
.M.S.MAA..
..A.ASMSM.
.M.S.M....
..........
S.S.S.S.S.
.A.A.A.A..
M.M.M.M.M.
..........
"""

// MARK: Parsing
let chars = input
    .split(separator: "\n")
    .map { Array($0) }

let grid = Grid(rows: chars)

print("parsing: \(CFAbsoluteTimeGetCurrent() - start)")
start = CFAbsoluteTimeGetCurrent()

// MARK: Part 1

var p1 = 0
for point in grid.points where grid[point] == "X" {
    for dir in Grid<Character>.Direction.allCases  {
        if grid.hasPrefix("XMAS", from: point, direction: dir) {
            p1 += 1
        }
    }
}

print("part 1: \(p1), \(CFAbsoluteTimeGetCurrent() - start)")

// MARK: Part 2

var p2 = 0
for point in grid.points where grid[point] == "A" {
    var firstPass = false
    for dir in Grid<Character>.Direction.diagonals.dropLast(2) {
        let a = grid.hasPrefix("MAS", from: point.offset(by: dir.inverse.offsets), direction: dir)
        let b = grid.hasPrefix("MAS", from: point.offset(by: dir.offsets), direction: dir.inverse)
        if a || b {
            if firstPass {
                p2 += 1
            } else {
                firstPass = true
            }
        }
    }
}

print("part 2: \(p2), \(CFAbsoluteTimeGetCurrent() - start)")
