//
//  HigherOrderTests.swift
//  LithoOperators_Tests
//
//  Created by Elliot Schrock on 8/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators
import Prelude
import UIKit
class HigherOrderTests: XCTestCase {
    func testTupleUnwrap() {
        let addTo20: (Int, Int) -> Bool = { $0 + $1 == 20 }
        let generateTuple: (Int) -> (Int, Int) = { ($0, 10 + $0) }
        let pipeline: (Int) -> Bool = generateTuple >>> ~(addTo20)
        XCTAssertTrue(pipeline(5))
        XCTAssertFalse(pipeline(2))
    }
    
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
    
    func testUnionOperator() throws {
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
        
        let function = toCall<>toAlsoCall
        
        function(argument)
        
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
    
    
    
    func testMutatingCurry() {
        let setSecondToNil: (inout [String?]) -> Void = { $0[1] = nil }
        var array: [String?] = ["Some", "Some", "Some", "Some"]
        array /> setSecondToNil
        XCTAssertNil(array[1])
    }
    
    func testMutatingUnion() {
        var int = 0
        let incrementOne: (inout Int) -> Void = { $0 = $0 + 1 }
        let incrementTwo: (inout Int) -> Void = { $0 = $0+2 }
        let incrementThree: (inout Int) -> Void = incrementOne <~> incrementTwo
        incrementThree(&int)
        XCTAssert(int == 3)
    }
    
    func testIgnoreOneArg() {
        var wasCalled: Bool = false
        let function: (String) -> Void = ignoreArg({ wasCalled = true })
        function("Lithobyte")
        XCTAssert(wasCalled)
    }
    
    func testIgnoreFirstArg() {
        let val: Int = 0
        let increment: (String, Int) -> Int = ignoreFirstArg(f: { $0 + 10 })
        XCTAssert(increment("Lithobyte", val) == 10)
    }
    
    func testIgnoreBothArgs() {
        var wasCalled: Bool = false
        let function: (String, String) -> Void = ignoreArgs({ wasCalled = true })
        function("Lithobyte", "Co")
        XCTAssert(wasCalled)
    }
    
    func testIgnoreAllArgs() {
        var wasCalled: [Bool] = [false, false, false, false]
        let function1: (String, String, String) -> Void = ignoreArgs({ wasCalled[0] = true})
        let function2: (String, String, String, String) -> Void = ignoreArgs({ wasCalled[1] = true})
        let function3: (String, String, String, String, String) -> Void = ignoreArgs({ wasCalled[2] = true})
        let function4: (String, String, String, String, String, String) -> Void = ignoreArgs({ wasCalled[3] = true})
        function1("Lithobyte", " Co", ".")
        function2("Litho", "byte", " Co", ".")
        function3("Lit", "ho", "byte", " Co", ".")
        function4("Lit", "ho", "by", "te", " Co", ".")
        
        XCTAssert(wasCalled.allSatisfy({ $0 }))
    }
    
    func testReturnValue() {
        let function: () -> String = returnValue("Lithobyte")
        XCTAssert(function() == "Lithobyte")
    }
}
