//
//  Assertion.swift
//  
//
//  Created by Steven Sherry on 10/13/19.
//

import Foundation
import Combine
import XCTest


public extension Subscribers {
  final class Assertion<Input, Failure: Error>: Subscriber {
    let assertion: Assert
    
    private let file: StaticString
    private let line: UInt
    private var subscription: Subscription?
    
    init(assert: Assert, file: StaticString = #file, line: UInt = #line) {
      assertion = assert
      self.file = file
      self.line = line
    }
    
    public func receive(subscription: Subscription) {
      print("received subscription")
      self.subscription = subscription
      subscription.request(.unlimited)
    }
    
    public func receive(_ input: Input) -> Subscribers.Demand {
      Swift.print("RECEIVED INPUT")
      assertion.input?(input)
      return .unlimited
    }
    
    public func receive(completion: Subscribers.Completion<Failure>) {
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
  public func cancel() {
    subscription?.cancel()
  }
}
