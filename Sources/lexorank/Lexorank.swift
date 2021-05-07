import Foundation

public struct Lexorank {
    var ranks: Set<Rank> = []

    @discardableResult
    public mutating func newRank() -> Rank {
        let rank = next()
        ranks.insert(rank)

        return rank
    }

    public mutating func remove(_ rank: Rank) {
        ranks.remove(rank)
    }

    @discardableResult
    public mutating func insertRank(at index: Int) -> Rank {
        switch index {
        case ranks.count:
            return newRank()
        case 0:
            let rank = self.rank(between: (0, ranks.sorted()[0]))
            ranks.insert(rank)
            return rank
        case let index:
            let sorted = ranks.sorted()
            
            let rank = self.rank(between: (sorted[index - 1], sorted[index]))
            ranks.insert(rank)
            return rank
        }
    }

    func next() -> Rank {
        let last = ranks.sorted().last?.rank ?? 0
        return Rank(integerLiteral: (last / Rank.step + 1) * Rank.step)
    }

    func rank(between ranks: (Rank, Rank)) -> Rank {
        let (after, before) = ranks
        return Rank(integerLiteral: (after.rank + before.rank) / 2)
    }
}

extension Lexorank {
    public init<S: Sequence>(_ sequence: S) where S.Element == Rank {
        self.ranks = Set(sequence)
    }
}

extension Lexorank: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Rank...) {
        self.init(elements)
    }
}
