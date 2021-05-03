extension Sequence {
    func sorted<T: Comparable>(by key: KeyPath<Element, T>) -> [Element] {
        sorted { $0[keyPath: key] < $1[keyPath: key] }
    }
}
