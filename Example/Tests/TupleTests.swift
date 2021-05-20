//
//  TupleTests.swift
//  LithoOperators_Tests
//
//  Created by Calvin Collins on 5/20/21.
//  Copyright © 2021 CocoaPods. All rights reserved.
//

import XCTest
import Prelude
@testable import LithoOperators

class TupleTests: XCTestCase {
    let stringArray = [lithobyte, thryv]
    let coArray = [Company(name: lithobyte), Company(name: thryv)]
    
    func testFzip2Args() {
        let getCount: ([String]) -> Int = { $0.count }
        let getCountAndFirst: ([String]) -> (Int, String?) = fzip(getCount, firstElement)
        let countAndFirst = getCountAndFirst(stringArray)
        XCTAssertEqual(countAndFirst.0, 2)
        XCTAssertEqual(countAndFirst.1!, "LithoByte, Co.")
    }
    
    func testFzip3Args() {
        let getCount: ([String]) -> Int = { $0.count }
        let getWordCountOfFirst: ([String]) -> Int? = { firstElement($0)?.count }
        let getCountAndFirst: ([String]) -> (Int, String?, Int?) = fzip(getCount, firstElement, getWordCountOfFirst)
        let countAndFirst = getCountAndFirst(stringArray)
        XCTAssertEqual(countAndFirst.0, 2)
        XCTAssertEqual(countAndFirst.1!, "LithoByte, Co.")
        XCTAssertEqual(countAndFirst.2!, 14)
    }
    
    func testFzip4Args() {
        let getCount: ([String]) -> Int = { $0.count }
        let getWordCountOfFirst: ([String]) -> Int? = { firstElement($0)?.count }
        let getWordCountOfSecond: ([String]) -> Int = { $0[1].count }
        let getCountAndFirst: ([String]) -> (Int, String?, Int?, Int) = fzip(getCount, firstElement, getWordCountOfFirst, getWordCountOfSecond)
        let countAndFirst = getCountAndFirst(stringArray)
        XCTAssertEqual(countAndFirst.0, 2)
        XCTAssertEqual(countAndFirst.1!, "LithoByte, Co.")
        XCTAssertEqual(countAndFirst.2!, 14)
        XCTAssertEqual(countAndFirst.3, 11)
    }
    
    func testFzip5Args() {
        let getCount: ([String]) -> Int = { $0.count }
        let getWordCountOfFirst: ([String]) -> Int? = { firstElement($0)?.count }
        let getWordCountOfSecond: ([String]) -> Int = { $0[1].count }
        let second: ([String]) -> String = { $0[1] }
        let getCountAndFirst: ([String]) -> (Int, String?, Int?, Int, String) = fzip(getCount, firstElement, getWordCountOfFirst, getWordCountOfSecond, second)
        let countAndFirst = getCountAndFirst(stringArray)
        XCTAssertEqual(countAndFirst.0, 2)
        XCTAssertEqual(countAndFirst.1!, "LithoByte, Co.")
        XCTAssertEqual(countAndFirst.2!, 14)
        XCTAssertEqual(countAndFirst.3, 11)
        XCTAssertEqual(countAndFirst.4, "Thryv, Inc.")
    }
    
    func testFzip6Args() {
        let getCount: ([String]) -> Int = { $0.count }
        let getWordCountOfFirst: ([String]) -> Int? = { firstElement($0)?.count }
        let getWordCountOfSecond: ([String]) -> Int = { $0[1].count }
        let second: ([String]) -> String = { $0[1] }
        let getCountAndFirst: ([String]) -> (Int, String?, Int?, Int, String, String?) = fzip(getCount, firstElement, getWordCountOfFirst, getWordCountOfSecond, second, firstElement)
        let countAndFirst = getCountAndFirst(stringArray)
        XCTAssertEqual(countAndFirst.0, 2)
        XCTAssertEqual(countAndFirst.1!, "LithoByte, Co.")
        XCTAssertEqual(countAndFirst.2!, 14)
        XCTAssertEqual(countAndFirst.3, 11)
        XCTAssertEqual(countAndFirst.4, "Thryv, Inc.")
        XCTAssertEqual(countAndFirst.5!, "LithoByte, Co.")
    }
    
    func testTupleMap() {
        var firstCalled = false
        var secondCalled = false
        let firstCalledSetter: (Int) -> Void = {
            if $0 == 1 {
                firstCalled = true
            }
        }
        let secondCalledSetter: (String) -> Void = {
            if $0 == "lithobyte" {
                secondCalled = true
            }
        }
        
        let firstSecondSetter = tupleMap(firstCalledSetter, secondCalledSetter)
        firstSecondSetter(1, "lithobyte")
        
        XCTAssertTrue(firstCalled)
        XCTAssertTrue(secondCalled)
    }
    
    func testTupleMap3Args() {
        var firstCalled = false
        var secondCalled = false
        var thirdCalled = false
        let firstCalledSetter: (Int) -> Void = {
            if $0 == 1 {
                firstCalled = true
            }
        }
        let secondCalledSetter: (String) -> Void = {
            if $0 == "lithobyte" {
                secondCalled = true
            }
        }
        let thirdCalledSetter: (Bool) -> Void = {
            thirdCalled = $0
        }
        let allSetter = tupleMap(firstCalledSetter, secondCalledSetter, thirdCalledSetter)
        allSetter(1, "lithobyte", true)
        
        XCTAssertTrue(firstCalled)
        XCTAssertTrue(secondCalled)
        XCTAssertTrue(thirdCalled)
    }
    
    func testTupleZip() {
        let equalsOne: (Int) -> Bool = { $0 == 1 }
        let count: (String) -> Int = { $0.count }
        let zipFn = tupleZip(equalsOne, count)
        let tuple1 = zipFn(1, "hello")
        XCTAssertTrue(tuple1.0)
        XCTAssertEqual(tuple1.1, 5)
    }
}
