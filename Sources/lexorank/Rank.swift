public struct Rank: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, CustomStringConvertible {
    var rank: UInt16

    static let step: UInt16 = 233

    public init(_ string: String) {
        precondition(string.count <= 3)
        self.rank = UInt16(string, radix: 36)!
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }

    public init(integerLiteral value: UInt16) {
        self.rank = value
    }

    public var description: String {
        String(rank, radix: 36)
    }
}

extension Rank: Comparable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.rank == rhs.rank
    }

    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.rank < rhs.rank
    }
}

extension Rank: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rank)
    }
}
