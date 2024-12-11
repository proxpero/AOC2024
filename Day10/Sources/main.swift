import Algorithms
import CoreAOC
import Foundation

var timer = Timer()

var input = try load(from: .module)
    .split(separator: "\n")
    .map { Array($0) }

// MARK: Parsing

let grid = Grid(rows: input)

print("Parsing", benchmark(timer))
timer.reset()

// MARK: Part 1

let p1 = 0

print("part 1: \(p1)", benchmark(timer))
timer.reset()

// MARK: Part 2

let p2 = 0

print("part 2: \(p2)", benchmark(timer))
