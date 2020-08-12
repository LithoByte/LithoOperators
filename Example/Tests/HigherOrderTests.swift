//
//  HigherOrderTests.swift
//  LithoOperators_Tests
//
//  Created by Elliot Schrock on 8/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators

class HigherOrderTests: XCTestCase {
    func testIgnoreFirst() {
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }
        let function: (String, Int) -> Bool = ignoreFirstArg(f: isEven)
        
        XCTAssertFalse(function("hi", 1))
        XCTAssertTrue(function("hi", 2))
    }
    
    func testIgnoreSecond() {
        let isEven: (Int) -> Bool = { $0 % 2 == 0 }
        let function: (Int, String) -> Bool = ignoreSecondArg(f: isEven)
        
        XCTAssertFalse(function(1, "hi"))
        XCTAssertTrue(function(2, "hi"))
    }
    
    func testUnionVoid() throws {
        var count = 0
        
        var wasCalled = false
        var callOrder = 0
        let toCall: () -> Void = {
            count += 1
            wasCalled = true
            callOrder = count
        }
        
        var wasAlsoCalled = false
        var alsoCallOrder = 0
        let toAlsoCall: () -> Void = {
            count += 1
            wasAlsoCalled = true
            alsoCallOrder = count
        }
        
        let function = union(toCall, toAlsoCall)
        
        function()
        
        XCTAssertTrue(wasCalled)
        XCTAssertTrue(wasAlsoCalled)
        XCTAssertEqual(callOrder, 1)
        XCTAssertEqual(alsoCallOrder, 2)
    }
    
    func testUnionOneArg() throws {
        let argument = "lithobyte"
        var count = 0
        
        var wasCalled = false
        var callOrder = 0
        let toCall: (String) -> Void = { string in
            count += 1
            wasCalled = string == argument
            callOrder = count
        }
        
        var wasAlsoCalled = false
        var alsoCallOrder = 0
        let toAlsoCall: (String) -> Void = { string in
            count += 1
            wasAlsoCalled = string == argument
            alsoCallOrder = count
        }
        
        let function = union(toCall, toAlsoCall)
        
        function(argument)
        
        XCTAssertTrue(wasCalled)
        XCTAssertTrue(wasAlsoCalled)
        XCTAssertEqual(callOrder, 1)
        XCTAssertEqual(alsoCallOrder, 2)
    }
    
    func testUnionTwoArgs() throws {
        let argument = "lithobyte"
        let secondArg = 1
        var count = 0
        
        var wasCalled = false
        var callOrder = 0
        let toCall: (String, Int) -> Void = { string, second in
            count += 1
            wasCalled = (string == argument) && (second == secondArg)
            callOrder = count
        }
        
        var wasAlsoCalled = false
        var alsoCallOrder = 0
        let toAlsoCall: (String, Int) -> Void = { string, second in
            count += 1
            wasAlsoCalled = (string == argument) && (second == secondArg)
            alsoCallOrder = count
        }
        
        let function: (String, Int) -> Void = union(toCall, toAlsoCall)
        
        function(argument, secondArg)
        
        XCTAssertTrue(wasCalled)
        XCTAssertTrue(wasAlsoCalled)
        XCTAssertEqual(callOrder, 1)
        XCTAssertEqual(alsoCallOrder, 2)
    }
    
    func testUnionThreeArgs() throws {
        let argument = "lithobyte"
        let secondArg = 1
        let thirdArg = false
        var count = 0
        
        var wasCalled = false
        var callOrder = 0
        let toCall: (String, Int, Bool) -> Void = { string, second, third in
            count += 1
            wasCalled = (string == argument) && (second == secondArg) && third == thirdArg
            callOrder = count
        }
        
        var wasAlsoCalled = false
        var alsoCallOrder = 0
        let toAlsoCall: (String, Int, Bool) -> Void = { string, second, third in
            count += 1
            wasAlsoCalled = (string == argument) && (second == secondArg) && third == thirdArg
            alsoCallOrder = count
        }
        
        let function: (String, Int, Bool) -> Void = union(toCall, toAlsoCall)
        
        function(argument, secondArg, thirdArg)
        
        XCTAssertTrue(wasCalled)
        XCTAssertTrue(wasAlsoCalled)
        XCTAssertEqual(callOrder, 1)
        XCTAssertEqual(alsoCallOrder, 2)
    }
}
