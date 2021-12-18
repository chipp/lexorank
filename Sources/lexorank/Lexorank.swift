import Foundation
import OrderedCollections

public struct Lexorank {
    var ranks: OrderedSet<Rank> = []

    @discardableResult
    public mutating func newRank() -> Rank {
        let rank = next()
        ranks.append(rank)

        return rank
    }

    public mutating func remove(_ rank: Rank) {
        ranks.remove(rank)
    }

    public mutating func remove(at index: Int) {
        ranks.remove(ranks[index])
    }

    @discardableResult
    public mutating func insertRank(at index: Int) -> Rank {
        switch index {
        case ranks.count:
            return newRank()
        case 0:
            let rank = self.rank(between: (.start, ranks[0]))
            ranks.insert(rank, at: index)
            return rank
        case let index:
            let rank = self.rank(between: (ranks[index - 1], ranks[index]))
            ranks.insert(rank, at: index)
            return rank
        }
    }

    public subscript(index: Int) -> Rank {
        ranks[index]
    }

    func next() -> Rank {
        let last = ranks.last?.rank ?? Rank.startInt
        return Rank(last + 1)
    }

    func rank(between ranks: (Rank, Rank)) -> Rank {
        let (after, before) = ranks
        return mid(after, before)
    }
}

extension Lexorank {
    public init<S: Sequence>(_ sequence: S) where S.Element == Rank {
        self.ranks = OrderedSet(sequence)
    }
}

extension Lexorank: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: Rank...) {
        self.init(elements)
    }
}
