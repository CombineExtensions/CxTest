//
//  Assertion.swift
//  
//
//  Created by Steven Sherry on 10/13/19.
//

import Combine
import XCTest

extension Subscribers {
  final class Assertion<Input, Failure: Error>: Subscriber {
    private let assertion: Assert
    private let onComplete: () -> ()
    private let file: StaticString
    private let line: UInt
    
    private var subscription: Subscription?
    
    init(assert: Assert, onComplete: @escaping () -> (), file: StaticString, line: UInt) {
      assertion = assert
      self.onComplete = onComplete
      self.file = file
      self.line = line
    }
    
    public func receive(subscription: Subscription) {
      self.subscription = subscription
      subscription.request(.unlimited)
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
      assertion.input?(input)
      return .unlimited
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
      defer { onComplete() }
      
      switch completion {
      case let .failure(error):
        if case .input = assertion {
          XCTFail("Failed with errors", file: file, line: line)
        }
        assertion.failure?(error)
      case .finished:
        if case .failure = assertion {
          XCTFail("Did not fail with errors", file: file, line: line)
        }
      }
    }
    
    public enum Assert {
      case failure((Failure) -> ())
      case input((Input) -> ())
      
      var failure: ((Failure) -> ())? {
        guard case let .failure(assertion) = self else { return nil }
        return assertion
      }
      
      var input: ((Input) -> ())? {
        guard case let .input(assertion) = self else { return nil }
        return assertion
      }
    }
  }
}
  
extension Subscribers.Assertion: Cancellable {
  func cancel() {
    subscription?.cancel()
  }
}
