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
  /// Assert that a publisher fails with a specified Error type
  /// - Parameter type: The expected error type
  /// - Parameter message: The optional message on failure
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert than a publisher fails with the expected error
  /// - Parameter error: The expected error
  /// - Parameter message: The optional message on failure
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert that a publisher fails
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert that published value(s) are equal to an expected value
  /// - Parameter value: The expected value
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
  func assert<T: Equatable>(
    equals value: T,
    expectation: XCTestExpectation? = nil,
    file: StaticString = #file,
    line: UInt = #line
  ) -> AnyCancellable where Output == T {
    
    assert(
      .input { input in
        XCTAssertEqual(input, value, file: file, line: line)
      },
      onComplete: fulfill(expectation),
      file: file,
      line: line
    )
  }
  
  /// Assert that published values are greater than the specified value
  /// - Parameter value: The value that published output should be greater than
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert that published values are greater than  or equal to the specified value
  /// - Parameter value: The value that published output should be greater than or equal to
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert that published values are less than  the specified value
  /// - Parameter value: The value that published output should be less than
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert that published values are less than or equal to  the specified value
  /// - Parameter value: The value that published output should be less than or equal to
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert published values are nil
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert published values are not nil
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
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
  
  /// Assert that an published values meet a given predicate
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
  /// - Parameter predicate: The predicate evaluated for each published value
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
  
  /// Assert that an expression is true
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
  /// - Parameter predicate: The predicate evaluated for each published value
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
  
  /// Assert that an expression is false
  /// - Parameter expectation: An optional expectation; if testing asynchrounous calls, this will need to be passed otherwise you will receive false positives.
  /// - Parameter predicate: The predicate evaluated for each published value
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
