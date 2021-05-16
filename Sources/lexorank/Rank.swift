public struct Rank: ExpressibleByStringLiteral, CustomStringConvertible {
    fileprivate(set) var string: String

    var rank: UInt64 {
        UInt64(string, radix: 36)!
    }

    static let start = Rank("10")
    static let startInt = Rank("10").rank

    public init(_ string: String) {
        self.string = String(UInt64(string, radix: 36)!, radix: 36)
    }

    init(_ int: UInt64) {
        self.string = String(int, radix: 36)
    }

    public init(stringLiteral value: String) {
        self.init(value)
    }

    public var description: String { string }
}

extension Rank: Comparable {
    public static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.rank == rhs.rank
    }

    public static func <(lhs: Self, rhs: Self) -> Bool {
        lhs.description < rhs.description
    }
}

extension Rank: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(rank)
    }
}

func mid(_ lhs: Rank, _ rhs: Rank) -> Rank {
    precondition(lhs != rhs)

    var lhs = lhs
    var rhs = rhs

    while lhs.description.count < rhs.description.count {
        lhs += "0"
    }

    while lhs.description.count > rhs.description.count {
        rhs += "0"
    }

    if rhs.rank - lhs.rank == 1 {
        lhs += "0"
        rhs += "0"
    }

    let avg = (lhs.rank + rhs.rank) / 2
    return Rank(avg)
}

func +(lhs: Rank, rhs: Character) -> Rank {
    precondition(rhs.isASCII)
    return Rank(lhs.string + rhs.lowercased())
}

func +=(lhs: inout Rank, rhs: Character) {
    precondition(rhs.isASCII)
    lhs.string += rhs.lowercased()
}
