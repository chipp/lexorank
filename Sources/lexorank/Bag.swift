import Foundation

public struct Bag<T: Identifiable> {
    private var items: [T.ID: (rank: Rank, item: T)] = [:]

    public init(items: [T]) {
        for item in items {
            append(item)
        }
    }

    public mutating func append(_ item: T) {
        let rank = next()
        items[item.id] = (rank: rank, item: item)
    }

    func next() -> Rank {
        let last = ranks.last?.rank ?? 0
        return Rank((last / Rank.step + 1) * Rank.step)
    }

    public mutating func put(_ item: T, before: T) {
        let before = items[before.id]!.rank
        let after = rank(before: before)
        let rank = self.rank(between: (after, before))
        items[item.id] = (rank: rank, item: item)
    }

    public mutating func put(_ item: T, after: T) {
        let after = items[after.id]!.rank
        let before = rank(after: after)
        let rank = before.map { before in self.rank(between: (after, before)) } ?? next()
        items[item.id] = (rank: rank, item: item)
    }

    func rank(before: Rank) -> Rank {
        ranks.last(where: { $0 < before }) ?? "0"
    }

    func rank(after: Rank) -> Rank? {
        ranks.first(where: { $0 > after })
    }

    func rank(between ranks: (Rank, Rank)) -> Rank {
        let (after, before) = ranks
        return Rank((after.rank + before.rank) / 2)
    }

    public var values: [T] {
        items.sorted(by: \.value.rank).map(\.value.item)
    }

    var ranks: [Rank] {
        items.sorted(by: \.value.rank).map(\.value.rank)
    }
}

extension Bag: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(items: elements)
    }
}
