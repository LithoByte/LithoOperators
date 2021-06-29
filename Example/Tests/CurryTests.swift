//
//  CurryTests.swift
//  LithoOperators_Tests
//
//  Created by Elliot Schrock on 8/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators

class CurryTests: XCTestCase {
    func testVoidCurry() {
        let allCaps: (String) -> String = { $0.uppercased() }
        
        let function = voidCurry("elliot", allCaps)
        
        XCTAssertEqual(function(), "ELLIOT")
    }
    
    func testVoidCurryOperator() {
        let allCaps: (String) -> String = { $0.uppercased() }
        
        let function = "elliot" *> allCaps
        
        XCTAssertEqual(function(), "ELLIOT")
    }
    
    func testIntoFirst() {
        let concat: (String, String) -> String = { $0 + $1 }
        
        let function = "LithoByte" *-> concat
        
        XCTAssertEqual(function(", Co."), "LithoByte, Co.")
    }
    
    func testIntoFirstOfThree() {
        let concat: (String, String, String) -> String = { $0 + $1 + $2 }
        
        let function = "LithoByte" *--> concat
        
        XCTAssertEqual(function(",", " Co."), "LithoByte, Co.")
    }
    
    func testIntoFirstOfFour() {
        let concat: (String, String, String, String) -> String = { $0 + $1 + $2 + $3 }
        
        let function = "LithoByte" *---> concat
        
        XCTAssertEqual(function(",", " ", "Co."), "LithoByte, Co.")
    }
    
    func testIntoFirstOfFive() {
        let concat: (String, String, String, String, String) -> String = { $0 + $1 + $2 + $3 + $4 }
        
        let function = "LithoByte" *----> concat
        
        XCTAssertEqual(function(",", " ", "C", "o."), "LithoByte, Co.")
    }
    
    func testIntoSecond() {
        let concat: (String, String) -> String = { $0 + $1 }
        
        let function = ", Co." -*> concat
        
        XCTAssertEqual(function("LithoByte"), "LithoByte, Co.")
    }
    
    func testTupleCurry() {
        let concat: (String, String, String) -> String = { $0 + $1 + $2 }
        
        let function = ("Calvin", " Collins") -**> concat
        
        XCTAssertEqual(function("Mr. "), "Mr. Calvin Collins")
    }
    
    func testThrupleCurry() {
        let sum4Numbers: (Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 }
        let add12: (Int) -> Int = (4,4,4) -***> sum4Numbers
        XCTAssert(add12(0) == 12)
    }
    
    func testIntoThird() {
        let sum3Numbers: (Int, Int, Int) -> Int = { $0 + $1 + $2 }
        let addSumTo10: (Int, Int) -> Int = 10 --*> sum3Numbers
        XCTAssert(addSumTo10(5, 5) == 20)
    }
    
    func testIntoFourth() {
        let sum4Numbers: (Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 }
        let addSumTo10: (Int, Int, Int) -> Int = 10 ---*> sum4Numbers
        XCTAssert(addSumTo10(10, 10, 10) == 40)
    }
    
    func testIntoFifth() {
        let sum5Numbers: (Int, Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 + $4 }
        let addSumTo10: (Int, Int, Int, Int) -> Int = 10 ----*> sum5Numbers
        XCTAssert(addSumTo10(5, 5, 5, 5) == 30)
    }
    
    func testIntoSixth() {
        let sum6Numbers: (Int, Int, Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 + $4 + $5 }
        let addSumTo10: (Int, Int, Int, Int, Int) -> Int = 10 -----*> sum6Numbers
        XCTAssert(addSumTo10(5, 5, 5, 5, 5) == 35)
    }
    
    func testTupleIntoThird() {
        let sum4Numbers: (Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 }
        let addTo10: (Int, Int) -> Int = (5, 5) --**> sum4Numbers
        XCTAssert(addTo10(5,5) == 20)
    }
    
    func testTupleIntoFirst() {
        let sum3Numbers: (Int, Int, Int) -> Int = { $0 + $1 + $2 }
        let addTo10: (Int) -> Int = (5, 5) -**> sum3Numbers
        XCTAssert(addTo10(10) == 20)
    }
    
    func testFunctionalCurry() {
        let boolToInt: (Bool) -> Int = { $0 ? 1 : 0 }
        let addTwoNumbers: (Int, Int) -> Int = (+)
        let addConditional: (Bool, Int) -> Int = boolToInt >*-> addTwoNumbers
        XCTAssertEqual(addConditional(true, 10), 11)
        XCTAssertEqual(addConditional(false, 10), 10)
        
        let addTwoConditionals: (Bool, Bool) -> Int = boolToInt >-*> addConditional
        XCTAssertEqual(addTwoConditionals(true, true), 2)
        XCTAssertEqual(addTwoConditionals(false, false), 0)
        XCTAssertEqual(addTwoConditionals(false, true), 1)
        XCTAssertEqual(addTwoConditionals(true, false), 1)
    }
    
    func testVoidFunctionalCurry() {
        let int: () -> Int = { 2 }
        let addTwoNumbers: (Int, Int) -> Int = (+)
        let addTwo: (Int) -> Int = int >*-> addTwoNumbers
        XCTAssertEqual(addTwo(1), 3)
        let addOne = { 1 } >*-> addTwoNumbers
        XCTAssertEqual(addOne(1), 2)
    }
    
    func testVoidFunctionalCurryMultParams() {
        let two = { 2 }
        let three = { 3 }
        let addThreeNumbers: (Int, Int, Int) -> Int = { $0 + $1 + $2 }
        let addTwo: (Int, Int) -> Int = two >*--> addThreeNumbers
        XCTAssertEqual(addTwo(1, 3), 6)
        let addOne = { 1 } >-*-> addThreeNumbers
        XCTAssertEqual(addOne(1, 3), 5)
        let addThree = three >--*> addThreeNumbers
        XCTAssertEqual(addThree(1, 2), 6)
    }
    
    func testFunctionalCurryTwoParams() {
        let addTwoNumbers: (Int, Int) -> Int = (+)
        let count: (String) -> Int = { $0.count }
        let addCountInFirst: (String, Int) -> Int = count >*-> addTwoNumbers
        let addCountInSecond: (Int, String) -> Int = count >-*> addTwoNumbers
        
        XCTAssertEqual(addCountInFirst("hello", 3), 8)
        XCTAssertEqual(addCountInSecond(3, "hello"), 8)
    }
    
    func testFunctionalCurryThreeParams() {
        let addThreeNumbers: (Int, Int, Int) -> Int = { $0 + $1 + $2 }
        let count: (String) -> Int = { $0.count }
        let addCountInFirst: (String, Int, Int) -> Int = count >*--> addThreeNumbers
        let addCountInSecond: (Int, String, Int) -> Int = count >-*-> addThreeNumbers
        let addCountInThird: (Int, Int, String) -> Int = count >--*> addThreeNumbers
        
        XCTAssertEqual(addCountInFirst("hello", 3, 2), 10)
        XCTAssertEqual(addCountInSecond(3, "hello", 2), 10)
        XCTAssertEqual(addCountInThird(3, 2, "hello"), 10)
    }
}
