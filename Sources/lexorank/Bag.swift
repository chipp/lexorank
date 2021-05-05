import Foundation

public struct Bag<T: Identifiable> {
    private var items: [T.ID: (rank: Rank, item: T)] = [:]

    public init(items: [T]) {
        for item in items {
            append(item)
        }
    }

    @discardableResult
    public mutating func append(_ item: T) -> Rank {
        let rank = next()
        items[item.id] = (rank: rank, item: item)

        return rank
    }

    public mutating func remove(_ item: T) {
        items.removeValue(forKey: item.id)
    }

    @discardableResult
    public mutating func insert(_ item: T, at index: Int) -> Rank {
        put(item, before: values[index])
    }

    func next() -> Rank {
        let last = ranks.last?.rank ?? 0
        return Rank((last / Rank.step + 1) * Rank.step)
    }

    @discardableResult
    public mutating func put(_ item: T, before: T) -> Rank {
        let before = items[before.id]!.rank
        let after = rank(before: before)
        let rank = self.rank(between: (after, before))
        items[item.id] = (rank: rank, item: item)

        return rank
    }

    @discardableResult
    public mutating func put(_ item: T, after: T) -> Rank {
        let after = items[after.id]!.rank
        let before = rank(after: after)
        let rank = before.map { before in self.rank(between: (after, before)) } ?? next()
        items[item.id] = (rank: rank, item: item)

        return rank
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

    public var count: Int {
        items.count
    }

    public var values: [T] {
        items.values.sorted(by: \.rank).map(\.item)
    }

    var ranks: [Rank] {
        items.values.sorted(by: \.rank).map(\.rank)
    }
}

extension Bag {
    public init<S: Sequence>(_ sequence: S) where S.Element == (rank: Rank, item: T) {
        for (rank, item) in sequence {
            items[item.id] = (rank, item)
        }
    }
}

extension Bag: ExpressibleByArrayLiteral {
    public init(arrayLiteral elements: T...) {
        self.init(items: elements)
    }
}
