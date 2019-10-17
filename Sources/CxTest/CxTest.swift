import XCTest
import Combine

extension Publisher {
  private func assert(
    _ assertion: Subscribers.Assertion<Output, Failure>.Assert,
    onComplete: @escaping () -> (),
    file: StaticString,
    line: UInt
  ) -> AnyCancellable {
    
    let _assert = Subscribers.Assertion(assert: assertion, onComplete: onComplete, file: file, line: line)
    subscribe(_assert)
    return AnyCancellable(_assert)
  }
  
  private func fulfill(_ expectation: XCTestExpectation?) -> () -> () {
    return { expectation?.fulfill() ?? () }
  }
}

public extension Publisher {
  func assertError<E: Error>(
    type: E.Type,
    message: String? = nil,
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable {
    
    assert(
      .failure { error in
        guard let _ = error as? E else {
          return XCTFail(message ?? "\(error.localizedDescription) is unable to be cast as \(E.self)", file: file, line: line)
        }
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assertError<E: Error & Equatable>(
    equals error: E,
    message: String? = nil,
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable {
    
    assert(
      .failure { e in
        guard let receivedError = e as? E else {
          return XCTFail(message ?? "\(error.localizedDescription) is unable to be cast as \(E.self)", file: file, line: line)
        }
        
        XCTAssertEqual(
          receivedError,
          error,
          message ?? "actual error \(receivedError.localizedDescription) is not equal to expected error \(error.localizedDescription)",
          file: file,
          line: line
        )
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assertFailure(
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable {

    assert(
      .failure { _ in },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assert<T: Equatable>(
    equals other: T,
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable where Output == T {
    
    assert(
      .input { value in
        XCTAssertEqual(value, other, file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assert<T: Comparable>(
    greaterThan value: T,
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable where Output == T {
    
    assert(
      .input { input in
        XCTAssertGreaterThan(input, value, file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assert<T: Comparable>(
    greaterThanOrEqualTo value: T,
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable where Output == T {
    
    assert(
      .input { input in
        XCTAssertGreaterThanOrEqual(input, value, file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assert<T: Comparable>(
    lessThan value: T,
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable where Output == T {
    
    assert(
      .input { input in
        XCTAssertLessThan(input, value, file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assert<T: Comparable>(
    lessThanOrEqualTo value: T,
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable where Output == T {
    
    assert(
      .input { input in
        XCTAssertLessThanOrEqual(input, value, file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assertNil<T>(
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable where Output == Optional<T> {
    
    assert(
      .input { input in
        XCTAssertNil(input, file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assertNotNil<T>(
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable where Output == Optional<T> {
    
    assert(
      .input { input in
        XCTAssertNotNil(input, file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assert(
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line,
    _ predicate: @escaping (Output) -> Bool
  ) -> AnyCancellable {
    
    assert(
      .input { input in
        XCTAssert(predicate(input), file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assert(
    expectation: XCTestExpectation,
    file: StaticString = #file,
    line: UInt = #line,
    _ predicate: @escaping (Output) -> Bool
  ) -> AnyCancellable {
    
    assert(
      .input { input in
        XCTAssert(predicate(input), file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assertTrue(
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line,
    _ predicate: @escaping (Output) -> Bool
  ) -> AnyCancellable {
    
    assert(
      .input { input in
        XCTAssertTrue(predicate(input), file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  func assertFalse(
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line,
    _ predicate: @escaping (Output) -> Bool
  ) -> AnyCancellable {
    
    assert(
      .input { input in
        XCTAssertFalse(predicate(input), file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
}
