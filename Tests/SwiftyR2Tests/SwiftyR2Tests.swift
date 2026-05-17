import XCTest

@testable import SwiftyR2

final class SwiftyR2Tests: XCTestCase {

    func testCoreCreationAndSimpleCommand() async throws {
        let core = await R2Core.create()

        let output = await core.cmd("?V")
        XCTAssertFalse(output.isEmpty, "Expected non-empty output from ?V command")
        XCTAssertTrue(
            output.lowercased().contains("radare2"),
            "Expected version output to mention radare2, got: \(output)"
        )
    }

    func testCmdWithLogsCapturesErrors() async throws {
        let core = await R2Core.create()

        let result = await core.cmdWithLogs("?v $FB @ 0xdeadbeef")
        XCTAssertTrue(
            result.hasErrors,
            "Expected an error log entry when querying $FB without an analyzed function, got logs: \(result.logs)"
        )
        XCTAssertTrue(
            result.errors.contains { $0.message.lowercased().contains("function") },
            "Expected at least one error mentioning 'function', got: \(result.errors.map { $0.message })"
        )
    }
}
