//
//  DictTests.swift
//  LithoOperators_Tests
//
//  Created by Calvin Collins on 6/16/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators

class DictTests: XCTestCase {
    func testGet() {
        let dict: [Int:String] = [1:"Calvin", 2:"Elliot"]
        let getter = keyToValue(for: dict)
        XCTAssertNotNil(getter(1))
        XCTAssertNil(getter(3))
        XCTAssertEqual(getter(1)!, "Calvin")
    }
    
    func testGetOperator() {
        let dict: [Int:String] = [1:"Calvin", 2: "Elliot"]
        let getter = ^dict
        XCTAssertNotNil(getter(1))
        XCTAssertEqual(getter(1)!, "Calvin")
    }
    
    func testMergeOperator() {
        let dict1: [Int:String] = [1:"Calvin", 2:"Elliot"]
        let dict2: [Int:String] = [1: "Collins"]
        let result: [Int: String] = dict1 << dict2
        XCTAssertEqual(result[1], "Collins")
    }
    
    func testOptMergeOperatorConflict() {
        let dict1: [Int:String] = [1:"Calvin", 2:"Elliot"]
        let dict2: [Int:String] = [1: "Collins", 3: "Schrock"]
        let result: [Int: String] = dict1 < dict2
        XCTAssertEqual(result[1], "Calvin")
        XCTAssertEqual(result[3], "Schrock")
    }
}
