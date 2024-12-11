import Algorithms

public struct Grid<Element> {
    public let width: Int
    public let height: Int

    public var minX: Int { topLeft.x }
    public var maxX: Int { topLeft.x + width - 1 }
    public var minCol: Int { minX }
    public var maxCol: Int { maxX }
    public var minY: Int { topLeft.y }
    public var maxY: Int { topLeft.y + height - 1 }
    public var minRow: Int { minY }
    public var maxRow: Int { maxY }
    public var xRange: Range<Int> { minX..<(maxX + 1) }
    public var yRange: Range<Int> { minY..<(maxY + 1) }
    public var rowRange: Range<Int> { minRow..<(maxRow + 1) }
    public var colRange: Range<Int> { minCol..<(maxCol + 1) }

    private var topLeft = Point(row: 0, col: 0)

    var elements: [[Element]]

    public init(rows: [[Element]]) {
        self.width = rows.first?.count ?? 0
        self.height = rows.count
        self.elements = rows
    }

    public subscript(row row: Int, column col: Int) -> Element {
        get { elements[row - minRow][col - minCol] }
        set { elements[row - minRow][col - minCol] = newValue }
    }

    public subscript(column col: Int) -> [Element] {
        elements.map { $0[col - minCol] }
    }

    public subscript(row row: Int) -> [Element] {
        elements[row - minRow]
    }

    public subscript(_ point: Point) -> Element {
        get { self[row: point.row, column: point.col] }
        set { self[row: point.row, column: point.col] = newValue }
    }

    public var points: [Point] {
        Array(product(rowRange, colRange).map { Point(row: $0.0, col: $0.1) })
    }

    public func points(from start: Point, direction: Grid.Direction) -> some Sequence<Point> {
        PointSequence(rowRange: rowRange, columnRange: colRange, direction: direction, current: start)
    }

    public func nextPoint(in direction: Direction, origin: Point) -> Point? {
        let point = origin.offset(by: direction.offsets)
        guard isValid(point: point) else { return nil }
        return point
    }

    public func isValid(point: Point) -> Bool {
        (minRow...maxRow) ~= point.row && (minCol...maxCol) ~= point.col
    }
}

extension Grid {
    public struct Point {
        public var row: Int
        public var col: Int

        public var x: Int {
            get { col }
            set { col = newValue }
        }

        public var y: Int {
            get { row }
            set { row = newValue}
        }

        public init(row: Int, col: Int) {
            self.row = row
            self.col = col
        }

        public init(x: Int, y: Int) {
            self.row = y
            self.col = x
        }

        public func offset(row: Int, col: Int) -> Self {
            Point(row: row + self.row, col: col + self.col)
        }

        public func offset(by delta: (rows: Int, cols: Int)) -> Self {
            offset(row: delta.rows, col: delta.cols)
        }
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
    public enum Direction: Equatable, Hashable, CaseIterable, Sendable {
        case up, down, left, right
        case upLeft, upRight, downLeft, downRight
        
        public static var cardinals: [Self] { [.up, .down, .left, .right] }
        public static var diagonals: [Self] { [.upLeft, .upRight, .downLeft, .downRight] }

        public var inverse: Self {
            switch self {
            case .up: .down
            case .down: .up
            case .left: .right
            case .right: .left
            case .upLeft: .downRight
            case .upRight: .downLeft
            case .downLeft: .upRight
            case .downRight: .upLeft
            }
        }

        public var offsets: (rows: Int, cols: Int) {
            switch self {
            case .up: (rows: -1, cols: 0)
            case .down: (rows: 1, cols: 0)
            case .left: (rows: 0, cols: -1)
            case .right: (rows: 0, cols: 1)
            case .upLeft:(rows: -1, cols: -1)
            case .upRight:(rows: -1, cols: 1)
            case .downLeft:(rows: 1, cols: -1)
            case .downRight:(rows: 1, cols: 1)
            }
        }
    }
}

extension Grid where Element: Equatable {
    public func hasPrefix(_ sequence: some Sequence<Element>, from origin: Point, direction: Direction) -> Bool {
        guard isValid(point: origin) else { return false }
        var current: Point? = origin
        for element in sequence {
            guard let candidate = current else { return false }
            guard self[candidate] == element else { return false }
            current = self.nextPoint(in: direction, origin: candidate)
        }

        return true
    }
}
