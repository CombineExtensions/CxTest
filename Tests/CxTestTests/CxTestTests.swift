import XCTest
import CxTest
import Combine
import CxDisposeBag

final class CxTestTests: XCTestCase {
  var bag: DisposeBag?
  
  override func setUp() {
    bag = DisposeBag()
  }
  
  override func tearDown() {
    bag = nil
  }
    
  func testFailureAssertionPasses() {
    let passthrough = PassthroughSubject<Void, URLError>()
    let expect = expectation(description: "general failure")

    passthrough.assertFailure(expectation: expect)
      .disposed(by: bag!)
    passthrough.send(completion: .failure(URLError(.appTransportSecurityRequiresSecureConnection)))

    wait(for: [expect], timeout: 1)
  }
  
  func testFailureTypeAssertionPasses() {
    let passthrough = PassthroughSubject<Void, URLError>()
    let expect = expectation(description: "failure type")
    
    passthrough.assertError(type: URLError.self, expectation: expect)
      .disposed(by: bag!)
    
    passthrough.send(completion: .failure(URLError(.appTransportSecurityRequiresSecureConnection)))
    
    wait(for: [expect], timeout: 1)
  }
  
  func testFailureEqualityAssertionPasses() {
    let passthrough = PassthroughSubject<Void, URLError>()
    let expect = expectation(description: "failure equals")
    
    passthrough.assertError(equals: URLError(.appTransportSecurityRequiresSecureConnection), expectation: expect)
      .disposed(by: bag!)
    
    passthrough.send(completion: .failure(URLError(.appTransportSecurityRequiresSecureConnection)))
    wait(for: [expect], timeout: 1)
  }
  
  func testEqualityPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    let expect = expectation(description: "equals")
    
    passthrough.assert(equals: 1, expectation: expect)
      .disposed(by: bag!)
    
    passthrough.send(1)
    passthrough.send(completion: .finished)
    wait(for: [expect], timeout: 1)
  }
  
  func testGreaterThanPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    let expect = expectation(description: "greater than")
    
    passthrough.assert(greaterThan: 5, expectation: expect)
      .disposed(by: bag!)
    
    passthrough.send(6)
    passthrough.send(completion: .finished)
    wait(for: [expect], timeout: 1)
  }
  
  func testGreaterThanOrEqualToPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    let expect = expectation(description: "greater than or equal to")
    
    passthrough.assert(greaterThanOrEqualTo: 5, expectation: expect)
      .disposed(by: bag!)
    
    passthrough.send(5)
    passthrough.send(6)
    passthrough.send(completion: .finished)
    wait(for: [expect], timeout: 1)
  }
  
  func testLessThanPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    let expect = expectation(description: "less than")
    
    passthrough.assert(lessThan: 6, expectation: expect)
      .disposed(by: bag!)
    
    passthrough.send(5)
    passthrough.send(completion: .finished)
    wait(for: [expect], timeout: 1)
  }

  func testLessThanOrEqualToPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    let expect = expectation(description: "less than or equal")
    
    passthrough.assert(lessThanOrEqualTo: 5, expectation: expect)
      .disposed(by: bag!)
    
    passthrough.send(5)
    passthrough.send(4)
    passthrough.send(completion: .finished)
    
    wait(for: [expect], timeout: 1)
  }
  
  func testAssertNilPasses() {
    let passthrough = PassthroughSubject<Int?, Never>()
    let `nil` = expectation(description: "nil")
    
    passthrough.assertNil(expectation: `nil`)
      .disposed(by: bag!)
    
    passthrough.send(nil)
    passthrough.send(completion: .finished)
    wait(for: [`nil`], timeout: 1)
  }
  
  func testAssertNotNilPasses() {
    let passthrough = PassthroughSubject<Int?, Never>()
    let notnil = expectation(description: "not nil")
    
    passthrough.assertNotNil(expectation: notnil)
      .disposed(by: bag!)
    
    passthrough.send(1)
    passthrough.send(completion: .finished)
    wait(for: [notnil], timeout: 1)
  }
  
  func testAssertOperatorPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    let expect = expectation(description: "assert")
    
    passthrough.assert(expectation: expect) { $0 == 1 }
      .disposed(by: bag!)
    
    passthrough.send(1)
    passthrough.send(completion: .finished)
    
    wait(for: [expect], timeout: 1)
  }
  
  func testAssertTrueOperatorPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    let `true` = expectation(description: "assert true")
    
    passthrough.assertTrue(expectation: `true`) { $0 == 1 }
      .disposed(by: bag!)
    
    passthrough.send(1)
    passthrough.send(completion: .finished)
    wait(for: [`true`], timeout: 1)
  }
  
  func testAssertFalseOperatorPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    let `false` = expectation(description: "assert false")
    
    passthrough.assertFalse(expectation: `false`) { $0 != 1 }
      .disposed(by: bag!)
    
    passthrough.send(1)
    passthrough.send(completion: .finished)
    wait(for: [`false`], timeout: 1)
  }
  
  func testAssertionWithExpectationPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    
    let equals = expectation(description: "equals")
    
    passthrough
      .assert(expectation: equals) { $0 == 1 }
      .disposed(by: self.bag!)
    
    
    passthrough.send(1)
    passthrough.send(1)
    passthrough.send(completion: .finished)
    
    wait(for: [equals], timeout: 4)
  }
}


