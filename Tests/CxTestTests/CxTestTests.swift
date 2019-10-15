import XCTest
@testable import CxTest
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
  
  func testInputAssertion_Passes() {
    let passthrough = PassthroughSubject<Int, Never>()
    
    passthrough.assert(.input { value in
      XCTAssertEqual(value, 1)
    })
    .disposed(by: bag!)
    
    passthrough.send(1)
  }
  
  func testFailureAssertion_Passes() {
    let passthrough = PassthroughSubject<Void, URLError>()
    
    passthrough.assertFailure()
      .disposed(by: bag!)
    
    passthrough.send(completion: .failure(URLError(.appTransportSecurityRequiresSecureConnection)))
  }
  
  func testFailureTypeAssertionPasses() {
    let passthrough = PassthroughSubject<Void, URLError>()
    
    passthrough.assertError(type: URLError.self)
      .disposed(by: bag!)
    
    passthrough.send(completion: .failure(URLError(.appTransportSecurityRequiresSecureConnection)))
  }
  
  func testFailureEqualityAssertionPasses() {
    let passthrough = PassthroughSubject<Void, URLError>()
    
    passthrough.assertError(equals: URLError(.appTransportSecurityRequiresSecureConnection))
      .disposed(by: bag!)
    
    passthrough.send(completion: .failure(URLError(.appTransportSecurityRequiresSecureConnection)))
  }
  
  func testEqualityPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    
    passthrough.assert(equals: 1)
      .disposed(by: bag!)
    
    passthrough.send(1)
  }
  
  func testGreaterThanPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    
    passthrough.assert(greaterThan: 5)
      .disposed(by: bag!)
    
    passthrough.send(6)
  }
  
  func testGreaterThanOrEqualToPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    
    passthrough.assert(greaterThanOrEqualTo: 5)
      .disposed(by: bag!)
    
    passthrough.send(5)
    passthrough.send(6)
  }
  
  func testLessThanPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    
    passthrough.assert(lessThan: 6)
      .disposed(by: bag!)
    
    passthrough.send(5)
  }

  func testLessThanOrEqualToPasses() {
    let passthrough = PassthroughSubject<Int, Never>()
    
    passthrough.assert(lessThanOrEqualTo: 5)
      .disposed(by: bag!)
    
    passthrough.send(5)
    passthrough.send(4)
  }
}
