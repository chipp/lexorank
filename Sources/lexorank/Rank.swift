struct Rank: ExpressibleByStringLiteral, ExpressibleByIntegerLiteral, CustomStringConvertible {
    var rank: UInt16

    static let step: UInt16 = 233

    init(_ string: String) {
        precondition(string.count <= 3)
        self.rank = UInt16(string, radix: 36)!
    }

    init(stringLiteral value: String) {
        self.init(value)
    }

    init(_ rank: UInt16) {
        self.rank = rank
    }

    init(integerLiteral value: UInt16) {
        self.rank = value
    }

    var description: String {
        String(rank, radix: 36)
    }
}

extension Rank: Comparable {
    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.rank == rhs.rank
    }

    static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.rank < rhs.rank
    }
}
