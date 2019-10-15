import XCTest
import CxDisposeBag
import Combine

extension Publisher {
  public func assert(_ assertion: Subscribers.Assertion<Output, Failure>.Assert, file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
    let _assert = Subscribers.Assertion(assert: assertion, file: file, line: line)
    subscribe(_assert)
    return AnyCancellable(_assert)
  }
}

public extension Publisher {
  func assertError<E: Error>(type: E.Type, message: String? = nil, file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
    assert(.failure { error in
      guard let _ = error as? E else {
        return XCTFail(message ?? "\(error.localizedDescription) is unable to be cast as \(E.self)", file: file, line: line)
      }
    }, file: file, line: line)
  }
  
  func assertError<E: Error & Equatable>(equals error: E, message: String? = nil, file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
    assert(.failure { e in
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
    }, file: file, line: line)
  }
  
  func assertFailure(file: StaticString = #file, line: UInt = #line) -> AnyCancellable {
    assert(.failure { _ in }, file: file, line: line)
  }
  
  func assert<T: Equatable>(equals other: T, file: StaticString = #file, line: UInt = #line) -> AnyCancellable where Output == T {
    assert(.input { value in
      XCTAssertEqual(value, other, file: file, line: line)
    }, file: file, line: line)
  }
  
  func assert<T: Comparable>(greaterThan value: T, file: StaticString = #file, line: UInt = #line) -> AnyCancellable where Output == T {
    assert(.input { input in
      XCTAssertGreaterThan(input, value, file: file, line: line)
    }, file: file, line: line)
  }
  
  func assert<T: Comparable>(greaterThanOrEqualTo value: T, file: StaticString = #file, line: UInt = #line) -> AnyCancellable where Output == T {
    assert(.input { input in
      XCTAssertGreaterThanOrEqual(input, value, file: file, line: line)
    }, file: file, line: line)
  }
  
  func assert<T: Comparable>(lessThan value: T, file: StaticString = #file, line: UInt = #line) -> AnyCancellable where Output == T {
    assert(.input { input in
      XCTAssertLessThan(input, value, file: file, line: line)
    }, file: file, line: line)
  }
  
  func assert<T: Comparable>(lessThanOrEqualTo value: T, file: StaticString = #file, line: UInt = #line) -> AnyCancellable where Output == T {
    assert(.input { input in
      XCTAssertLessThanOrEqual(input, value, file: file, line: line)
    }, file: file, line: line)
  }
}
