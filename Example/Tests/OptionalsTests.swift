//
//  OptionalsTests.swift
//  LithoOperators_Tests
//
//  Created by Elliot Schrock on 8/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators

class OptionalsTests: XCTestCase {
    func testIfExecuteOperatorReturning() throws {
        let allCaps: (String) -> String = { $0.uppercased() }
        let name: String? = "elliot"
        let nilName: String? = nil
        
        XCTAssertNotNil(name ?> allCaps)
        XCTAssertEqual(name ?> allCaps, "ELLIOT")
        XCTAssertNil(nilName ?> allCaps)
    }
    
    func testIfExecuteOperatorVoid() throws {
        var wasCalled = false
        let toCall: (String) -> Void = { _ in wasCalled = true }
        let name: String? = "elliot"
        
        var shouldntHaveBeenCalled = false
        let notToCall: (String) -> Void = { _ in shouldntHaveBeenCalled = true }
        let nilName: String? = nil
        
        name ?> toCall
        nilName ?> notToCall
        
        XCTAssertTrue(wasCalled)
        XCTAssertFalse(shouldntHaveBeenCalled)
    }
    
    func testIfExecuteReturning() throws {
        let allCaps: (String) -> String = { $0.uppercased() }
        let name: String? = "elliot"
        let nilName: String? = nil
        
        XCTAssertNotNil(ifExecute(name, allCaps))
        XCTAssertEqual(ifExecute(name, allCaps), "ELLIOT")
        XCTAssertNil(ifExecute(nilName, allCaps))
    }
    
    func testIfExecuteVoid() throws {
        var wasCalled = false
        let toCall: (String) -> Void = { _ in wasCalled = true }
        let name: String? = "elliot"
        
        var shouldntHaveBeenCalled = false
        let notToCall: (String) -> Void = { _ in shouldntHaveBeenCalled = true }
        let nilName: String? = nil
        
        ifExecute(name, toCall)
        ifExecute(nilName, notToCall)
        
        XCTAssertTrue(wasCalled)
        XCTAssertFalse(shouldntHaveBeenCalled)
    }
    
    func testOptionalCompositionReturning() throws {
        let allCaps: (String) -> String = { $0.uppercased() }
        let evenAnnouncer: (Int) -> String? = { $0 % 2 == 0 ? "even" : nil }
        let function = evenAnnouncer >?> allCaps
        
        XCTAssertNil(function(1))
        XCTAssertEqual(function(2), "EVEN")
    }
    
    func testDoubleOptionalCompositionReturning() throws {
        let allCaps: (String) -> String? = { $0.uppercased() }
        let evenAnnouncer: (Int) -> String? = { $0 % 2 == 0 ? "even" : nil }
        let function = evenAnnouncer >?> allCaps
        
        let evenResult = function(2)
        
        XCTAssertNil(function(1))
        XCTAssertEqual(evenResult, "EVEN")
        XCTAssert(evenResult is String?)
    }
    
    func testOptionalCompositionVoid() throws {
        var wasCalled = false
        let toCall: (String) -> Void = { _ in wasCalled = true }
        let evenAnnouncer: (Int) -> String? = { $0 % 2 == 0 ? "even" : nil }
        let function = evenAnnouncer >?> toCall
        
        function(1)
        XCTAssertFalse(wasCalled)
        function(2)
        XCTAssertTrue(wasCalled)
    }
    
    func testCoalesceNil() throws {
        let nilAnnouncer = coalesceNil(with: "nil")
        
        XCTAssertEqual(nilAnnouncer(nil), "nil")
        XCTAssertEqual(nilAnnouncer("hi"), "hi")
    }
    
    func testOptionalCast() throws {
        if let int: Int = optionalCast(object: "string") {
            XCTFail("cast a String to an Int '\(int)' somehow...")
        }
        
        let anObject: Any = "elliot"
        if let string: String = optionalCast(object: anObject) {
            XCTAssertEqual(string, anObject as! String)
        } else {
            XCTFail("String was not cast to String")
        }
    }
}
