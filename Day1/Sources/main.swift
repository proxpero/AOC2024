import Foundation

var date = Date()

let input = try Bundle.module.url(forResource: "Input", withExtension: nil).flatMap {
    try String(contentsOf: $0, encoding: .utf8)
}!

// left and right columns as separate arrays of Ints
let (lhs, rhs) = input
    .split(separator: "\n")
    .map { $0.split(separator: " ") }
    .reduce(into: ([Int](), [Int]())) {
        $0.0.append(Int($1[0])!)
        $0.1.append(Int($1[1])!)
    }

print("parsing: \(-date.timeIntervalSinceNow)")
date = Date()

let p1 = zip(lhs.sorted(), rhs.sorted())
    .map { abs($0.0 - $0.1) }
    .reduce(into: 0) { $0 += $1 }

print("part 1: \(p1), \(-date.timeIntervalSinceNow)")

let counts: [Int: Int] = rhs.reduce(into: [:]) {
    $0[$1, default: 0] += 1
}

let p2 = lhs.reduce(into: 0) {
    $0 += (counts[$1] ?? 0) * $1
}

print("part 2: \(p2), \(-date.timeIntervalSinceNow)")
