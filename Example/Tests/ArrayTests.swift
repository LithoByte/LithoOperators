//
//  ArrayTests.swift
//  LithoOperators_Tests
//
//  Created by Elliot Schrock on 8/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators

struct Company {
    var name: String?
}

let lithobyte = "LithoByte, Co."
let thryv = "Thryv, Inc."

class ArrayTests: XCTestCase {
    let stringArray = [lithobyte, thryv]
    let coArray = [Company(name: lithobyte), Company(name: thryv)]
    
    func testFirstElement() {
        XCTAssertEqual(firstElement(stringArray), lithobyte)
    }
    
    func testSeqKeyPathMap() {
        XCTAssertEqual(coArray.map(\Company.name), stringArray)
    }
    
    func testSeqKeyPathCompactMap() {
        let nilNameCoArray = coArray + [Company(name: nil)]
        XCTAssertEqual(nilNameCoArray.compactMap(\Company.name), stringArray)
    }
    
    func testFreeKeyPathMap() {
        XCTAssertEqual(map(array: coArray, \Company.name), stringArray)
    }
    
    func testFreeKeyPathMap1() {
        XCTAssertEqual(map(\Company.name)(coArray), stringArray)
    }
    
    func testFreeFuncMap() {
        XCTAssertEqual(map(array: coArray, f: { (co: Company) in return co.name }), stringArray)
    }
    
    func testFreeFuncMap1() {
        let numbers: [Int] = [0, 1, 2]
        let increment: ([Int]) -> [Int] = map(f: { $0 + 1 })
        let newNumbers: [Int] = increment(numbers)
        XCTAssert(newNumbers == [1,2,3])
    }
    
    func testFreeKeyPathCompactMap() {
        let nilNameCoArray = coArray + [Company(name: nil)]
        XCTAssertEqual(compactMap(array: nilNameCoArray, \Company.name), stringArray)
    }
    
    func testFreeKeyPathCompactMap1() {
        let nilNameCoArray = coArray + [Company(name: nil)]
        XCTAssertEqual(compactMap(\Company.name)(nilNameCoArray), stringArray)
    }
    
    func testFreeFuncCompactMap() {
        let nilNameCoArray = coArray + [Company(name: nil)]
        XCTAssertEqual(compactMap(array: nilNameCoArray, f: { (co: Company) in return co.name }), stringArray)
    }
    
    func testFreeFuncCompactMap1() {
        let nilNameCoArray = coArray + [Company(name: nil)]
        let getNonNilNames: ([Company]) -> [String] = compactMap(f: { $0.name })
        let nonNilNames = getNonNilNames(nilNameCoArray)
        XCTAssert(nonNilNames.count == 2)
    }
    
    func testFreeFuncFilter() {
        let filterArray: ([String]) -> [String] = filter(f: { $0 == "LithoByte, Co." })
        let lithoArray = filterArray(stringArray)
        XCTAssert(lithoArray.count == 1)
    }
    
    func testFreeFuncFilter1() {
        let array: [Int] = [1, 0, 1, 0]
        let newArray = filter(array: array, f: { $0 > 0})
        XCTAssert(newArray.count == 2)
    }
    
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
    
    func testSortBy() {
        struct IntHolder {
            var int: Int
        }
        
        let firstHolder = IntHolder(int: 0)
        let secondHolder = IntHolder(int: 1)
        var holders = [secondHolder, firstHolder]
        holders.sortBy(keyPath: \.int)
        XCTAssert(holders[0].int == 0)
    }
    
    func testSortByDefault() {
        var array: [Company] = [Company(name: "LithoByte, Co."), Company(name: "Aardvark, Inc."), Company(name: nil)]
        array.sortBy(keyPath: \.name, defaultValue: "AAAA")
        XCTAssert(array[0].name == nil && array[1].name == "Aardvark, Inc.")
    }
    
    func testSortedBy() {
        struct IntHolder {
            var int: Int
        }
        
        let firstHolder = IntHolder(int: 0)
        let secondHolder = IntHolder(int: 1)
        let holders = [secondHolder, firstHolder]
        
        let sorted = holders.sortedBy(keyPath: \.int)
        XCTAssert(sorted[0].int == 0 && sorted[1].int == 1)
    }
    
    func testDefaultSortedBy() {
        var array: [Company] = [Company(name: "LithoByte, Co."), Company(name: "Aardvark, Inc."), Company(name: nil)]
        let sorted = array.sortedBy(keyPath: \.name, defaultValue: "AAAA")
        XCTAssert(sorted[0].name == nil && sorted[1].name == "Aardvark, Inc.")
    }
    
    func testFreeFuncSortedBy() {
        struct IntHolder {
            var int: Int
        }
        
        let firstHolder = IntHolder(int: 0)
        let secondHolder = IntHolder(int: 1)
        let holders = [secondHolder, firstHolder]
        
        let sorted: ([IntHolder]) -> [IntHolder] = sortedBy(keyPath: \IntHolder.int)
        let sortedArray = sorted(holders)
        XCTAssert(sortedArray[0].int == 0 && sortedArray[1].int == 1)
    }
    
    func testFreeFuncDefaultSortedBy() {
        var array: [Company] = [Company(name: "LithoByte, Co."), Company(name: "Aardvark, Inc."), Company(name: nil)]
        let sorted: ([Company]) -> [Company] = sortedBy(keyPath: \.name, defaultValue: "AAAA")
        let sortedArray = sorted(array)
        XCTAssert(sortedArray[0].name == nil && sortedArray[1].name == "Aardvark, Inc.")
    }
    
    // TUPLES
    
    func testFirst() {
        let tuple: (Int, Int) = (0,0)
        let incrementFirst: (Int) -> (Int) = { $0 + 1 }
        let firstTuple = first(incrementFirst)(tuple)
        XCTAssert(firstTuple.0 == 1)
        let secondTuple = second(incrementFirst)(tuple)
        XCTAssert(secondTuple.1 == 1)
        
    }
}
