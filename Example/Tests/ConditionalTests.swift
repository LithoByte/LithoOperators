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
    
    func testIfThenCall() {
        let shouldCallThen = true
        var wasCalled = false
        var wasWronglyCalled = false
        
        ifThenCall(shouldCallThen, { wasCalled = true }, else: { wasWronglyCalled = true })
        
        XCTAssert(wasCalled)
        XCTAssertFalse(wasWronglyCalled)
    }
    
    func testIfThenCallElse() {
        let shouldCallThen = false
        var wasCalled = false
        var wasWronglyCalled = false
        
        ifThenCall(shouldCallThen, { wasWronglyCalled = true }, else: { wasCalled = true })
        
        XCTAssert(wasCalled)
        XCTAssertFalse(wasWronglyCalled)
    }
    
    func testIfThenT() {
        let shouldCallThen: () -> Bool = { true }
        var number = 0
        
        let resultFunc = ifThen(shouldCallThen, { (newVal: Int) in number = newVal }, else: { number = -1 })
        resultFunc(1)
        
        XCTAssertEqual(number, 1)
    }
    
    func testIfThenElseT() {
        let shouldCallThen: () -> Bool = { false }
        var number = 0
        
        let resultFunc = ifThen(shouldCallThen, { (newVal: Int) in number = newVal }, else: { number = -1 })
        resultFunc(1)
        
        XCTAssertEqual(number, -1)
    }
    
    func testIfThen() {
        let shouldCallThen: () -> Bool = { true }
        var number = 0
        
        let resultFunc = ifThen(shouldCallThen, { number = 1 }, else: { number = -1 })
        resultFunc()
        
        XCTAssertEqual(number, 1)
    }
    
    func testIfThenElse() {
        let shouldCallThen: () -> Bool = { false }
        var number = 0
        
        let resultFunc = ifThen(shouldCallThen, { number = 1 }, else: { number = -1 })
        resultFunc()
        
        XCTAssertEqual(number, -1)
    }
}
