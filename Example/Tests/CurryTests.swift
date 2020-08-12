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
}
