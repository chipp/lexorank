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
    func testRankBetween() {
        let bag: Lexorank = ["6h", "cy", "jf", "pw", "wd"]
        XCTAssertEqual(bag.rank(between: ("jf", "pw")), "mn")
    }

    func testAppend() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw", "wd"]
        XCTAssertEqual(bag.newRank(), "12u")
        XCTAssertEqual(bag.ranks, ["6h", "cy", "jf", "pw", "wd", "12u"])
    }

    func testRemove() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw", "wd"]
        bag.remove("jf")

        XCTAssertEqual(bag.ranks, ["6h", "cy", "pw", "wd"])
    }

    func testRemoveAt() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw", "wd"]
        bag.remove(at: 2)
        bag.remove(at: 1)

        XCTAssertEqual(bag.ranks, ["6h", "pw", "wd"])
    }

    func testInsertAt() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw"]

        XCTAssertEqual(bag.insertRank(at: 2), "g6")
        XCTAssertEqual(bag.ranks, ["6h", "cy", "g6", "jf", "pw"])
    }

    func testInsertAtStart() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw"]

        XCTAssertEqual(bag.insertRank(at: 0), "38")
        XCTAssertEqual(bag.ranks, ["38", "6h", "cy", "jf", "pw"])
    }

    func testInsertAtEnd() {
        var bag: Lexorank = ["6h", "cy", "jf", "pw"]

        XCTAssertEqual(bag.insertRank(at: 4), "wd")
        XCTAssertEqual(bag.ranks, ["6h", "cy", "jf", "pw", "wd"])
    }
}
