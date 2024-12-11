import Algorithms
import CoreAOC
import Foundation

var start = CFAbsoluteTimeGetCurrent()

var input = try load(from: .module)

//input = """
//190: 10 19
//3267: 81 40 27
//83: 17 5
//156: 15 6
//7290: 6 8 6 15
//161011: 16 10 13
//192: 17 8 14
//21037: 9 7 18 13
//292: 11 6 16 20
//"""

// MARK: Parsing

typealias Operator = (Int, Int) -> Int

struct Expression {
    let values: [Int]
    let result: Int
}

extension Expression {
    init(line: some StringProtocol) {
        let segments = line.split(separator: ":")
        self.result = Int(segments[0])!
        self.values = segments[1].split(separator: " ").map { Int($0)! }
    }
}

let expressions = input.split(separator: "\n").map(Expression.init)

print("parsing: \(CFAbsoluteTimeGetCurrent() - start)")
start = CFAbsoluteTimeGetCurrent()

// MARK: Part 1

expressions.forEach {
    print($0)
}

func eval(final: Int, ns: [Int], ops: [(Int, Int) -> Int]) -> Bool {
    guard ns.count > 1 else {
        return ns.first == final
    }

    var ns = ns
    let a = ns.removeFirst()
    let b = ns.removeFirst()
    return ops.contains { op in
        eval(final: final, ns: [op(a, b)] + ns, ops: ops)
    }
}

let p1 = 0





print("part 1: \(p1), \(CFAbsoluteTimeGetCurrent() - start)")



// MARK: Part 2

let p2 = 0

print("part 2: \(p2), \(CFAbsoluteTimeGetCurrent() - start)")
