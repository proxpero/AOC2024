//extension Sequence {
//    public func reduceSum(_ f: (Element) -> Bool) -> Int {
//        reduce(0) { $0 + f($1) }
//    }
//
//    public func reduceProduct(_ f: (Element) -> Bool) -> Int {
//        reduce(1) { $0 * f($1) }
//    }
//
//    public func reduceMax(_ f: (Element) -> Bool) -> Element? {
//        reduce(Int.min) {
//            let value = f($1)
//            return value > $0 ? value : $0
//        }
//    }
//
//    public func reduceMin(_ f: (Element) -> Bool) -> Element? {
//        reduce(Int.max) {
//            let value = f($1)
//            return value < $0 ? value : $0
//        }
//    }
//
//    public func minMax(_ f: (Element) -> (Int)) -> ClosedRange<Int> {
//        let (min, max) = reduce((Int.max, Int.min)) {
//            let value = f($1)
//            return (value < $0.0 ? value : $0.0, value > $0.1 ? value : $0.1)
//        }
//
//        return min...max
//    }
//}
//
//extension Sequence where Element: Int {
//    func minMax() -> ClosedRange<Int> {
//        minMax(\.self)
//    }
//
//    var sum: Int {
//        reduceSum(\.self)
//    }
//}
//
//extension Array {
//    var middle: Element {
//        self[count / 2]
//    }
//}
