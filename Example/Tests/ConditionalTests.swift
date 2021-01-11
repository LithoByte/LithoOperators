//
//  ConditionalTests.swift
//  LithoOperators_Tests
//
//  Created by William Collins on 12/8/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators
struct Incrementor: ConditionalApply {
  public var val: Int = 0
}
class ConditionalTests: XCTestCase {
  

  
  func testIfApply() throws {
    var bool: Bool = false
    var inc = Incrementor()
    let increment: (Incrementor) -> Incrementor = {
      return Incrementor(val: $0.val + 1)
    }
    inc = inc.ifApply(bool, increment)
    XCTAssert(inc.val == 0)
    bool = true
    inc = inc.ifApply(bool, increment)
    XCTAssert(inc.val == 1)
  }
}
