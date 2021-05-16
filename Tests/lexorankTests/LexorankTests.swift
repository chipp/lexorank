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

final class LexorankTests: XCTestCase {
    func testPlus() {
        XCTAssertEqual(Rank("a") + "a", Rank("aa"))
        XCTAssertEqual(Rank("aaaaa") + "z", Rank("aaaaaz"))

        var rank = Rank("aaa")
        rank += "z"

        XCTAssertEqual(rank, "aaaz")
    }

    func testMid() {
        XCTAssertEqual(mid("1", "z"), "i")
        XCTAssertEqual(mid("11", "zz"), "ii")
        XCTAssertEqual(mid("aa", "bb"), "as")

        XCTAssertEqual(mid("aaa", "bb"), "asn")
        XCTAssertEqual(mid("aaa", "b"), "an5")

        XCTAssertEqual(mid("aa", "bbz"), "asz")
        XCTAssertEqual(mid("a", "bbz"), "anz")

        XCTAssertEqual(mid("1", "2"), "1i")
        XCTAssertEqual(mid("aaa", "aab"), "aaai")
    }

    func testRankBetween() {
        let bag: Lexorank = ["6h", "cy", "jf", "pw", "wd"]
        XCTAssertEqual(bag.rank(between: ("jf", "pw")), "mn")
    }

    func testAppend() {
        var bag: Lexorank = []
        XCTAssertEqual(bag.newRank(), "11")
        XCTAssertEqual(bag.ranks.sorted(), ["11"])

        XCTAssertEqual(bag.newRank(), "12")
        XCTAssertEqual(bag.ranks.sorted(), ["11", "12"])

        for _ in 0...33 {
            _ = bag.newRank()
        }

        XCTAssertEqual(bag.ranks.sorted(), [
            "11", "12", "13", "14", "15", "16", "17", "18", "19",
            "1a", "1b", "1c", "1d", "1e", "1f", "1g", "1h", "1i",
            "1j", "1k", "1l", "1m", "1n", "1o", "1p", "1q", "1r",
            "1s", "1t", "1u", "1v", "1w", "1x", "1y", "1z", "20"
        ])
    }

    func testRemove() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw", "wd"]
        bag.remove("jf")

        XCTAssertEqual(bag.ranks.sorted(), ["6h", "cy", "pw", "wd"])
    }

    func testRemoveAt() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw", "wd"]
        bag.remove(at: 2)
        bag.remove(at: 1)

        XCTAssertEqual(bag.ranks.sorted(), ["6h", "pw", "wd"])
    }

    func testInsertAt() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw"]

        XCTAssertEqual(bag.insertRank(at: 2), "g6")
        XCTAssertEqual(bag.ranks.sorted(), ["6h", "cy", "g6", "jf", "pw"])
    }

    func testInsertAtStart() {
        var bag: Lexorank = ["11"]

        XCTAssertEqual(bag.insertRank(at: 0), "10i")
        XCTAssertEqual(bag.ranks.sorted(), ["10i", "11"])
    }

    func testInsertAtEnd() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw"]

        XCTAssertEqual(bag.insertRank(at: 4), "px")
        XCTAssertEqual(bag.ranks.sorted(), ["6h", "cy", "jf", "pw", "px"])
    }
}
