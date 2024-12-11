import Foundation

public typealias Timer = Date
public func benchmark(_ startDate: Timer) -> String {
    "⏱️ \(startDate.millisecondsAgo) ms"
}

extension Timer {
    public mutating func reset() {
        self = Date()
    }
}
