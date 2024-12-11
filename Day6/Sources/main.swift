import Algorithms
import CoreAOC
import Foundation

var start = CFAbsoluteTimeGetCurrent()

var input = try Bundle.module.url(forResource: "Input", withExtension: nil).flatMap {
    try String(contentsOf: $0, encoding: .utf8)
}!

let sample = """
....#.....
.........#
..........
..#.......
.......#..
..........
.#..^.....
........#.
#.........
......#...
"""

// MARK: Parsing

typealias Direction = Grid<Character>.Direction
typealias Point = Grid<Character>.Point

extension Direction {
    init(char: Character) {
        switch char {
        case "^": self = .up
        case ">": self = .right
        case "v": self = .down
        case "<": self = .left
        default:
            fatalError("Invalid direction: \(char)")
        }
    }
}

let chars = sample
    .split(separator: "\n")
    .map { Array($0) }
var grid = Grid(rows: chars)
let origin = grid.points.first { "^><v".contains(grid[$0]) }!

print("parsing: \(CFAbsoluteTimeGetCurrent() - start)")
start = CFAbsoluteTimeGetCurrent()

// MARK: Part 1

var position: Point = origin
var direction = Direction(char: grid[origin])

var visited: Set<Point> = []
while grid.isValid(point: position) {
    visited.insert(position)
    guard let next = grid.nextPoint(in: direction, origin: position) else {
        break
    }

    if grid[next] == "#" {
        direction = direction.turningRight
    } else {
        position = next
    }
}

let p1 = visited.count

print("part 1: \(p1), \(CFAbsoluteTimeGetCurrent() - start)")

// MARK: Part 2

struct Patrol: Hashable {
    var position: Point
    var direction: Direction

    mutating func turnRight() {
        direction = direction.turningRight
    }
}

extension Grid<Character> {
    @MainActor
    func hasCycle(from origin: Patrol) -> Bool {
        var patrol = origin
        var visited: Set<Patrol> = []
        while true {
            if visited.contains(patrol) {
                return true
            }

            print("insering patrol \(patrol)")
            visited.insert(patrol)

            guard let next = grid.nextPoint(in: patrol.direction, origin: patrol.position) else {
                print("Exit")
                break
            }

            if grid[next] == "#" {
                patrol.turnRight()
            } else {
                patrol.position = next
            }
        }

        return false
    }
}

var patrol = Patrol(position: origin, direction: .init(char: grid[origin]))
var history: [Patrol] = []
let p2 = visited.count { point in
//    if grid[point] == "." { return false }
    var temp = grid
    temp[point] = "#"
    return temp.hasCycle(from: patrol)
}

//while grid.isValid(point: position) {
//    history.append(patrol)
//
//    guard let next = grid.nextPoint(in: patrol.direction, origin: patrol.position) else {
//        break
//    }
//
//    if grid[next] == "#" {
//        patrol.turnRight()
//    } else {
//        if patrol.position == .init(row: 6, col: 4) {
//            history.forEach {
//                print($0)
//            }
//            let new = Patrol(
//                position: patrol.position,
//                direction: patrol.direction.turningRight
//            )
//            print("candidate", grid.nextPoint(in: patrol.direction.turningRight, origin: patrol.position))
//            print("new", new)
//        }
//        let candidate = Patrol(position: patrol.position, direction: patrol.direction.turningRight)
//        if history.last(where: { $0 == candidate }) != nil {
//            print("found \(patrol.position)")
//            p2 += 1
//        } else {
//            if patrol.position == .init(row: 7, col: 6) {
//                print("lskdjf")
//            }
//            print("Not found at \(patrol.position)")
//        }
//        patrol.position = next
//    }
//}

print("part 2: \(p2), \(CFAbsoluteTimeGetCurrent() - start)")
