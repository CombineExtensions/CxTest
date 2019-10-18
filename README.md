# CxTest
## A collection of test helpers for Combine

![Build Status](https://github.com/CombineExtensions/CxTest/workflows/CI/badge.svg) ![Current Version](https://img.shields.io/github/v/tag/CombineExtensions/CxTest?color=purple&label=Version) ![swift-package-manager](https://img.shields.io/badge/Swift%20Package%20Manager-compatible-red.svg) ![platforms](https://img.shields.io/badge/Platform-iOS%20|%20macOS%20|%20watchOS-informational.svg) ![swift-version](https://img.shields.io/badge/Swift-5.1-orange.svg) ![license](https://img.shields.io/badge/License-MIT-c41d3a.svg)

Testing Combine can be cumbersome. If you need to test any logic to Publishers you create or expose, one of the only options is to throw logic into a `Sink`:

```swift
func testPublisherFailsWithSpecifiedError() {
  let failing = Fail(outputType: Void.self, failure: SomeError())
    .sink(receiveCompletion: { completion in 
      switch completion {
        case .finished:
          XCTFail("Did not fail with an error")
        case .failure:
          return
      }
    }, receiveValue: { output in
      XCTFail("Should not have received value: \(output)")
    })
}
```

With **CxTest**, the previous example is simplified to this:
```swift
let failing = Fail(outputType: Void.self, failure: SomeError())
    .assertFailure()
```

When you're creating your own Combine publishers or operators, testing can normally be done using something like a `PassthroughSubject` to avoid having to actually call an asynchrounous API:
```swift
func testValuesAreLessThan10() {
  let passthrough = PassthroughSubject<Int, Never>()

  let clamped = passthrough
      .clamp(range: Int.min..<10)
      .assert(lessThan: 10)

  passthrough.send(20)
  passthrough.send(40)
  passthrough.send(completion: .finished)
}
```

**CxTest** also has full support for asynchronous APIs:
```swift
func testValuesAreLessThan10Async() {
  let clampedExpectation = XCTestExpectation(description: "clamped")

  let clamped = AsyncNumberPublisher()
      .clamp(range: Int.min..<10)
      .assert(lessThan: 10, expectation: clampedExpectation)

  wait(for: [clampedExpectation], timeout: 5)
}
```

**CxTest** has a comparable operator for every XCTest assertion with the exception of `XCTAssertThrowsError` and `XCTAssertNoThrow`. These error throwing assertions are replaced by `assertFailure()`, `assertError(type:expectation:)`, and `assertError(equals:expectation:)` operators.
