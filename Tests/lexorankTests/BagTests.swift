import XCTest
import Foundation
import Difference
@testable import lexorank

public func XCTAssertEqual<T: Equatable>(_ received: @autoclosure () throws -> T, _ expected: @autoclosure () throws -> T, file: StaticString = #filePath, line: UInt = #line) {
    do {
        let received = try received()
        let expected = try expected()
        XCTAssertTrue(received == expected, "Found difference for \n" + diff(expected, received).joined(separator: ", "), file: file, line: line)
    }
    catch {
        XCTFail("Caught error while testing: \(error)", file: file, line: line)
    }
}

struct Task: Hashable, Identifiable {
    var id: UUID = UUID()
    var title: String

    init(title: String) {
        self.title = title
    }

    static func ==(lhs: Self, rhs: Self) -> Bool {
        lhs.id == rhs.id
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

final class lexorankTests: XCTestCase {
    let t1 = Task(title: "1")
    let t2 = Task(title: "2")
    let t3 = Task(title: "3")
    let t4 = Task(title: "4")
    let t5 = Task(title: "5")

    func testSortByKey() {
        XCTAssertEqual([1, 3, 5, 4, 6, 2].sorted(by: \.self), [1, 2, 3, 4, 5, 6])
    }

    func testInitializer() {
        let bag: Bag = [t1, t2, t3, t4, t5]
        XCTAssertEqual(bag.values, [t1, t2, t3, t4, t5])
        XCTAssertEqual(bag.ranks, ["6h", "cy", "jf", "pw", "wd"])
    }

    func testRankBefore() {
        let bag: Bag = [t1, t2, t3, t4, t5]
        XCTAssertEqual(bag.rank(before: "cy"), "6h")
        XCTAssertEqual(bag.rank(before: "6h"), "0")
    }

    func testRankAfter() {
        let bag: Bag = [t1, t2, t3, t4, t5]
        XCTAssertEqual(bag.rank(after: "jf"), "pw")
        XCTAssertNil(bag.rank(after: "wd"))
    }

    func testRankBetween() {
        let bag: Bag = [t1, t2, t3, t4, t5]
        XCTAssertEqual(bag.rank(between: ("jf", "pw")), "mn")
    }

    func testPutBefore() {
        var bag: Bag = [t1, t2, t3, t4, t5]

        XCTAssertEqual(bag.put(t1, before: t5), "t4")
        XCTAssertEqual(bag.values, [t2, t3, t4, t1, t5])
        XCTAssertEqual(bag.ranks, ["cy", "jf", "pw", "t4", "wd"])

        XCTAssertEqual(bag.put(t5, before: t2), "6h")
        XCTAssertEqual(bag.values, [t5, t2, t3, t4, t1])
        XCTAssertEqual(bag.ranks, ["6h", "cy", "jf", "pw", "t4"])
    }

    func testPutAfter() {
        var bag: Bag = [t1, t2, t3, t4, t5]

        XCTAssertEqual(bag.put(t1, after: t4), "t4")
        XCTAssertEqual(bag.values, [t2, t3, t4, t1, t5])
        XCTAssertEqual(bag.ranks, ["cy", "jf", "pw", "t4", "wd"])

        XCTAssertEqual(bag.put(t2, after: t5), "12u")
        XCTAssertEqual(bag.values, [t3, t4, t1, t5, t2])
        XCTAssertEqual(bag.ranks, ["jf", "pw", "t4", "wd", "12u"])
    }

    func testAppend() {
        var bag: Bag = [t1, t2, t3, t4, t5]
        let t6 = Task(title: "6")

        bag.append(t6)

        XCTAssertEqual(bag.values, [t1, t2, t3, t4, t5, t6])
        XCTAssertEqual(bag.ranks, ["6h", "cy", "jf", "pw", "wd", "12u"])
    }

    func testRemove() {
        var bag: Bag = [t1, t2, t3, t4, t5]
        bag.remove(t3)

        XCTAssertEqual(bag.values, [t1, t2, t4, t5])
        XCTAssertEqual(bag.ranks, ["6h", "cy", "pw", "wd"])
    }

    func testInsertAt() {
        var bag: Bag = [t1, t2, t4, t5]

        XCTAssertEqual(bag.insert(t3, at: 2), "g6")
        XCTAssertEqual(bag.values, [t1, t2, t3, t4, t5])
        XCTAssertEqual(bag.ranks, ["6h", "cy", "g6", "jf", "pw"])
    }

    func testInsertAtEnd() {
        var bag: Bag = [t1, t2, t3, t4]
        bag.insert(t5, at: 4)

        XCTAssertEqual(bag.values, [t1, t2, t3, t4, t5])
        XCTAssertEqual(bag.ranks, ["6h", "cy", "jf", "pw", "wd"])
    }
}
