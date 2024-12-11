import Algorithms

public struct Grid<Element> {
    public let width: Int
    public let height: Int
    public var elements: [[Element]]
    private let zero = Point(row: 0, col: 0)

    public init(rows: [[Element]]) {
        self.width = rows.first?.count ?? 0
        self.height = rows.count
        self.elements = rows
    }
}

public extension Grid {
    var minCol: Int { zero.col }
    var maxCol: Int { zero.col + width - 1 }
    var minRow: Int { zero.row }
    var maxRow: Int { zero.row + height - 1 }
    var rowRange: Range<Int> { minRow..<(maxRow + 1) }
    var colRange: Range<Int> { minCol..<(maxCol + 1) }

    subscript(row row: Int, column col: Int) -> Element {
        get { elements[row - minRow][col - minCol] }
        set { elements[row - minRow][col - minCol] = newValue }
    }

    subscript(column col: Int) -> [Element] {
        elements.map { $0[col - minCol] }
    }

    subscript(row row: Int) -> [Element] {
        elements[row - minRow]
    }

    subscript(_ point: Point) -> Element {
        get { self[row: point.row, column: point.col] }
        set { self[row: point.row, column: point.col] = newValue }
    }

    var points: [Point] {
        Array(product(rowRange, colRange).map { Point(row: $0.0, col: $0.1) })
    }

    func points(from start: Point, direction: Direction) -> some Sequence<Point> {
        PointSequence(rowRange: rowRange, columnRange: colRange, direction: direction, current: start)
    }

    func nextPoint(in direction: Direction, origin: Point) -> Point {
        origin.offset(by: direction.offsets)
    }

    func contains(point: Point) -> Bool {
        (minRow...maxRow) ~= point.row && (minCol...maxCol) ~= point.col
    }
}

extension Grid {
    public struct Point: Equatable, Hashable {
        public var row: Int
        public var col: Int

        public init(row: Int, col: Int) {
            self.row = row
            self.col = col
        }
    }
}

public extension Grid.Point {
    func offset(row: Int, col: Int) -> Self {
        Self(row: row + self.row, col: col + self.col)
    }

    func offset(by delta: (rows: Int, cols: Int)) -> Self {
        offset(row: delta.rows, col: delta.cols)
    }
}

extension Grid {
    struct PointSequence: Sequence, IteratorProtocol {
        let rowRange: Range<Int>
        let columnRange: Range<Int>

        var direction: Grid.Direction
        var current: Point

        mutating func next() -> Grid.Point? {
            let result = current
            guard rowRange ~= result.row && columnRange ~= result.col else {
                return nil
            }
            let next = current.offset(by: direction.offsets)
            current = next
            return result
        }
    }
}

extension Grid {
    public enum Direction: CaseIterable {
        case up
        case right
        case down
        case left
    }
}

public extension Grid.Direction {
    var inverse: Self {
        self.rotatedClockwise(by: 2)
    }

    func rotatedClockwise(by increment: Int = 1) -> Self {
        let newIndex = (Self.allCases.firstIndex(of: self)! + increment).quotientAndRemainder(
            dividingBy: Self.allCases.count
        ).remainder
        return Self.allCases[newIndex]
    }

    var offsets: (rows: Int, cols: Int) {
        switch self {
        case .up: (rows: -1, cols: 0)
        case .right: (rows: 0, cols: 1)
        case .down: (rows: 1, cols: 0)
        case .left: (rows: 0, cols: -1)
        }
    }
}

public extension Grid where Element: Equatable {
    func hasPrefix(_ sequence: some Sequence<Element>, from origin: Point, direction: Direction) -> Bool {
        guard self.contains(point: origin) else { return false }
        var current: Point? = origin
        for element in sequence {
            guard let candidate = current else { return false }
            guard self[candidate] == element else { return false }
            current = self.nextPoint(in: direction, origin: candidate)
        }

        return true
    }
}
