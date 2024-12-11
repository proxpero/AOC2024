import Algorithms
import CoreAOC
import Foundation

var timer = Timer()

var input = try load(from: .module)
//input = "2333133121414131402"

struct DiskMap {
    var store: [Int?] = []

    init(_ chars: [Character]) {
        var chars = chars
        var result: [Int?] = []
        var id: Int = 0
        while chars.count > 0 {
            let file = chars.removeFirst().unsafeInteger
            let space: Int = !chars.isEmpty ? chars.removeFirst().unsafeInteger : 0
            result.append(contentsOf: Array(repeating: id, count: file))
            result.append(contentsOf: Array(repeating: nil, count: space))
            id += 1
        }

        self.store = result
    }

    var checksum: Int {
        var result: Int = 0
        for (index, value) in store.enumerated() where value != nil {
            result += (value! * index)
        }

        return result
    }
}

// MARK: Parsing

extension DiskMap {
    init(_ input: String) {
        self.init(input.map(\.self))
    }
}

print("Parsing", benchmark(timer))
timer.reset()

// MARK: Part 1

extension DiskMap {
    mutating func defragBlocks() {
        var lastDestination: Int = store.startIndex
        var lastOrigin: Int = store.endIndex - 1
        while let destination = store[lastDestination...].firstIndex(where: { $0 == nil }),
              let origin = store[...lastOrigin].lastIndex(where: { $0 != nil }),
              destination < origin
        {
          store.swapAt(destination, origin)
          lastDestination = destination
          lastOrigin = origin
        }
    }
}

var diskMap = DiskMap(input)
diskMap.defragBlocks()
let p1 = diskMap.checksum

print("part 1: \(p1)", benchmark(timer))

// MARK: Part 2

extension DiskMap {
    mutating func defragFiles() {
        var currentId: Int = store.last(where: { $0 != nil })!!
        var lastDestination: Int = store.startIndex
        var lastOrigin: Int = store.endIndex - 1
        var sizeOfNextBlock = 0

        var lastRanges: Range<Int> {
            store.firstIndex(of: currentId)!..<store.lastIndex(of: currentId)!
        }

        var rangeOfLastIds: Range<Int> {
            let lastIndex = store.lastIndex(of: currentId)!
            var firstIndex = lastIndex
            while let first = store[firstIndex], first == currentId {
                firstIndex -= 1
            }

            lastOrigin = store[firstIndex + 1]!
            return firstIndex..<lastIndex
        }

        let nextAvailableDestinationRange: Range<Int> = {
            let startIndex = store[lastDestination...].firstIndex(where: { $0 == nil })!
            var endIndex = startIndex
            while store[endIndex] == nil {
                endIndex += 1
            }

            return startIndex..<endIndex
        }()

        while
    }
}

diskMap = DiskMap(input)
diskMap.defragFiles()
let p2 = diskMap.checksum

print("part 2: \(p2)", benchmark(timer))
