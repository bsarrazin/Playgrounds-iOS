import Foundation
import XCTest

class AsyncFoo {
    func perform(complete: () -> Void) {
        // noop
    }
}

class TestCase: XCTestCase {

    func testAsyncFoo_whenCallingPerform_shouldNeverCallCompletion() throws {
        // Arrange
        let exp = expectation(description: name)
        exp.isInverted = true
        let sut = AsyncFoo()

        // Act
        sut.perform { exp.fulfill() }

        // Assert
        wait(for: [exp], timeout: 10)
    }

}

TestCase.defaultTestSuite.run()
