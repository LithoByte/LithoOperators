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
        
        let function = ", Co." >||> concat
        
        XCTAssertEqual(function("LithoByte"), "LithoByte, Co.")
    }
    
    func testIntoSecond() {
        let concat: (String, String) -> String = { $0 + $1 }
        
        let function = "LithoByte" >|> concat
        
        XCTAssertEqual(function(", Co."), "LithoByte, Co.")
    }
    
    func testTupleCurry() {
        let concat: (String, String, String) -> String = { $0 + $1 + $2 }
        
        let function = ("Calvin", " Collins") >||> concat
        
        XCTAssertEqual(function("Mr. "), "Mr. Calvin Collins")
    }
    
    func testThrupleCurry() {
        let sum4Numbers: (Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 }
        let add12: (Int) -> Int = (4,4,4) >||> sum4Numbers
        XCTAssert(add12(0) == 12)
    }
    
    func testIntoThird() {
        let sum3Numbers: (Int, Int, Int) -> Int = { $0 + $1 + $2 }
        let addSumTo10: (Int, Int) -> Int = 10 >|||> sum3Numbers
        XCTAssert(addSumTo10(5, 5) == 20)
    }
    
    func testIntoFourth() {
        let sum4Numbers: (Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 }
        let addSumTo10: (Int, Int, Int) -> Int = 10 >||||> sum4Numbers
        XCTAssert(addSumTo10(10, 10, 10) == 40)
    }
    
    func testIntoFifth() {
        let sum5Numbers: (Int, Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 + $4 }
        let addSumTo10: (Int, Int, Int, Int) -> Int = 10 >|||||> sum5Numbers
        XCTAssert(addSumTo10(5, 5, 5, 5) == 30)
    }
    
    func testIntoSixth() {
        let sum6Numbers: (Int, Int, Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 + $4 + $5 }
        let addSumTo10: (Int, Int, Int, Int, Int) -> Int = 10 >||||||> sum6Numbers
        XCTAssert(addSumTo10(5, 5, 5, 5, 5) == 35)
    }
    
    func testTupleIntoThird() {
        let sum4Numbers: (Int, Int, Int, Int) -> Int = { $0 + $1 + $2 + $3 }
        let addTo10: (Int, Int) -> Int = (5, 5) >|||> sum4Numbers
        XCTAssert(addTo10(5,5) == 20)
    }
    
    func testTupleIntoFirst() {
        let sum3Numbers: (Int, Int, Int) -> Int = { $0 + $1 + $2 }
        let addTo10: (Int) -> Int = (5, 5) >|> sum3Numbers
        XCTAssert(addTo10(10) == 20)
    }
}
