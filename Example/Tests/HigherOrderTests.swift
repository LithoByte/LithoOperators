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
    func testVoidCompose() {
        let namer: () -> String = { "Elliot" }
        let caps: (String) -> String = { $0.uppercased() }
        
        XCTAssertEqual((namer >*> caps)(), "ELLIOT")
    }
    
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
    
    func testUnionConcat() throws {
        var count = 0
        var count2 = 0
        var addToCount: (Int) -> Void = {
            count += $0
        }
        let addToSecondCount: (Int) -> Void = {
            count2 += $0
        }
        addToCount <>= addToSecondCount
        addToCount(1)
        XCTAssertTrue(count == 1)
        XCTAssertTrue(count2 == 1)
    }
    
    func testOptUnionConcat() {
        var count = 0
        let addToCount: (Int) -> Void = {
            count += $0
        }
        var none: ((Int) -> Void)? = nil
        none <>= addToCount
        none?(3)
        XCTAssertEqual(count, 3)
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
    
    func testIgnoreIrrelevantArgs1to3() {
        let returnOneIfTrue: (Bool) -> Int = { $0 ? 1 : 0 }
        let secondAndThirdIgnored: (Bool, Int, Int) -> Int = ignoreIrrelevantArgs(f: returnOneIfTrue)
        let firstAndThirdIgnored: (Int, Bool, Int) -> Int = ignoreIrrelevantArgs(f: returnOneIfTrue)
        let firstAndSecondIgnored: (Int, Int, Bool) -> Int = ignoreIrrelevantArgs(f: returnOneIfTrue)
        
        XCTAssertEqual(secondAndThirdIgnored(true, 1, 1), 1)
        XCTAssertEqual(secondAndThirdIgnored(false, 1, 1), 0)
        
        XCTAssertEqual(firstAndThirdIgnored(1, true, 1), 1)
        XCTAssertEqual(firstAndThirdIgnored(1, false, 1), 0)
        
        XCTAssertEqual(firstAndSecondIgnored(1, 1, true), 1)
        XCTAssertEqual(firstAndSecondIgnored(1, 1, false), 0)
    }
    
    func testIgnoreIrrelevantArgs2to3() {
        let addTwoNums: (Int, Int) -> Int = (+)
        let firstIgnored: (Bool, Int, Int) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        let secondIgnored: (Int, Bool, Int) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        let thirdIgnored: (Int, Int, Bool) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        
        XCTAssertEqual(firstIgnored(true, 1, 1), 2)
        XCTAssertEqual(secondIgnored(1, true, 1), 2)
        XCTAssertEqual(thirdIgnored(1, 1, true), 2)
    }
    
    func testIgnoreIrrelevantArgs2to4() {
        let addTwoNums: (Int, Int) -> Int = (+)
        let firstAndSecondIgnored: (Bool, Bool, Int, Int) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        let firstAndThirdIgnored: (Bool, Int, Bool, Int) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        let firstAndFourthIgnored: (Bool, Int, Int, Bool) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        let secondAndThirdIgnored: (Int, Bool, Bool, Int) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        let secondAndFourthIgnored: (Int, Bool, Int, Bool) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        let thirdAndFourthIgnored: (Int, Int, Bool, Bool) -> Int = ignoreIrrelevantArgs(f: addTwoNums)
        
        XCTAssertEqual(firstAndSecondIgnored(true, true, 1, 1), 2)
        XCTAssertEqual(firstAndThirdIgnored(true, 1, true, 1), 2)
        XCTAssertEqual(firstAndFourthIgnored(true, 1, 1, true), 2)
        XCTAssertEqual(secondAndThirdIgnored(1, true, true, 1), 2)
        XCTAssertEqual(secondAndFourthIgnored(1, true, 1, true), 2)
        XCTAssertEqual(thirdAndFourthIgnored(1, 1, true, true), 2)
    }
    
    func testIgnoreIrrelevantArgs3to4() {
        let addThreeNums: (Int, Int, Int) -> Int = { $0 + $1 + $2 }
        let ignoreFirst: (Bool, Int, Int, Int) -> Int = ignoreIrrelevantArgs(f: addThreeNums)
        let ignoreSecond: (Int, Bool, Int, Int) -> Int = ignoreIrrelevantArgs(f: addThreeNums)
        let ignoreThird: (Int, Int, Bool, Int) -> Int = ignoreIrrelevantArgs(f: addThreeNums)
        let ignoreFourth: (Int, Int, Int, Bool) -> Int = ignoreIrrelevantArgs(f: addThreeNums)
        
        XCTAssertEqual(ignoreFirst(true, 1, 1, 1), 3)
        XCTAssertEqual(ignoreSecond(1, true, 1, 1), 3)
        XCTAssertEqual(ignoreThird(1, 1, true, 1), 3)
        XCTAssertEqual(ignoreFourth(1, 1, 1, true), 3)
    }
    
    func testReturnValue() {
        let function: () -> String = returnValue("Lithobyte")
        XCTAssert(function() == "Lithobyte")
    }
}
