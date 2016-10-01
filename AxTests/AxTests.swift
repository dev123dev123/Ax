//
//  AxTests.swift
//  AxTests
//
//  Created by Wilson Balderrama on 9/28/16.
//  Copyright © 2016 Wilson Balderrama. All rights reserved.
//

import XCTest
@testable import Ax

class AxTests: XCTestCase {
  
  override func setUp() {
    super.setUp()
    // Put setup code here. This method is called before the invocation of each test method in the class.
  }
  
  override func tearDown() {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    super.tearDown()
  }
  
  func runAsync(after seconds: Int, closure: @escaping () -> Void) {
    let time = DispatchTime.now() + DispatchTimeInterval.seconds(seconds)
    let queue = DispatchQueue(label: "com.example.runqueue")
    queue.asyncAfter(deadline: time, qos: .background, flags: .inheritQoS) {
      closure()
    }
  }
  

  
  func testRunningThreeTasksAndEnsureAreBeingCalledSerially() {
    let ex = expectation(description: "Testing tasks are being executed serially")
    var counter = 0
    
    Ax.serial(tasks: [
      { done in
        self.runAsync(after: 5) {
          counter += 1
          
          XCTAssertEqual(counter, 1)
          
          done(nil)
        }
      },
      { done in
        self.runAsync(after: 2) {
          counter += 1
          
          XCTAssertEqual(counter, 2)
          
          done(nil)
        }
      },
      { done in
        self.runAsync(after: 1) {
          counter += 1
          
          XCTAssertEqual(counter, 3)
          
          done(nil)
        }
      }
    ]) { error in
      XCTAssertEqual(counter, 3)
      XCTAssertNil(error)
      ex.fulfill()
    }
    
    waitForExpectations(timeout: 20) { (error) in
      if let error = error {
        XCTFail("error: \(error)")
      }
    }
  }
  
  func testRunningThreeTasksInParallelAndEnsureResultCallIsDoneAtFinalState() {
    let ex = expectation(description: "Testing tasks that run in parallel and are finished before result closure is called")
    var counter = 0
    
    Ax.parallel(
      tasks: [
        { done in
          self.runAsync(after: 2) {
            counter += 1
            done(nil)
          }
        },
        { done in
          self.runAsync(after: 3) {
            counter += 1
            done(nil)
          }
        }
      ],
      result: { error in
        XCTAssertNil(error)
        XCTAssertEqual(counter, 2)
        ex.fulfill()
      })
    
    waitForExpectations(timeout: 8) { (error) in
      if let error = error {
        XCTFail("error: \(error)")
      }
    }
  }
  
  func testRunningThreeTasksAndEnsureResultCallIsDoneAtFinalStage() {
    let ex = expectation(description: "Testing tasks are being called before result closure is called")
    var counter = 0
    
    Ax.serial(tasks: [
      { done in
        self.runAsync(after: 2) {
          counter += 1
          done(nil)
        }
      },
      { done in
        self.runAsync(after: 3) {
          counter += 1
          done(nil)
        }
      },
      { done in
        self.runAsync(after: 1) {
          counter += 1
          done(nil)
        }
      }
    ]) { (error) in
      XCTAssertEqual(counter, 3)
      XCTAssertNil(error)
      ex.fulfill()
    }
    
    waitForExpectations(timeout: 8) { (error) in
      if let error = error {
        XCTFail("error: \(error)")
      }
    }
    
  }
  
}
