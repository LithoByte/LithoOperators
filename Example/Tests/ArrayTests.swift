//
//  ArrayTests.swift
//  LithoOperators_Tests
//
//  Created by Elliot Schrock on 8/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators
import Prelude

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
        let array: [Company] = [Company(name: "LithoByte, Co."), Company(name: "Aardvark, Inc."), Company(name: nil)]
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
    
    func testFreeFuncSortedByDescending() {
        struct IntHolder {
            var int: Int
        }
        
        let firstHolder = IntHolder(int: 0)
        let secondHolder = IntHolder(int: 1)
        let holders = [secondHolder, firstHolder]
        
        let sorted: ([IntHolder]) -> [IntHolder] = sortedByDescending(keyPath: \IntHolder.int)
        let sortedArray = sorted(holders)
        XCTAssert(sortedArray[0].int == 1 && sortedArray[1].int == 0)
    }
    
    func testFreeFuncForEach() {
        struct IntHolder {
            var int: Int
        }
        
        var int1 = 0
        var int2 = 0
        
        let firstHolder = IntHolder(int: 1)
        let secondHolder = IntHolder(int: 2)
        let holders = [firstHolder, secondHolder]
        let assign: (IntHolder) -> Void = {
            if $0.int == 1 {
                int1 = $0.int
            }
            if $0.int == 2 {
                int2 = $0.int
            }
        }
        
        forEach(array: holders, f: assign)
        
        XCTAssertEqual(int1, 1)
        XCTAssertEqual(int2, 2)
    }
    
    func testFreeFuncGenForEach() {
        struct IntHolder {
            var int: Int
        }
        
        var int1 = 0
        var int2 = 0
        
        let firstHolder = IntHolder(int: 1)
        let secondHolder = IntHolder(int: 2)
        let holders = [firstHolder, secondHolder]
        let assign: (IntHolder) -> Void = {
            if $0.int == 1 {
                int1 = $0.int
            }
            if $0.int == 2 {
                int2 = $0.int
            }
        }
        
        let fe = forEach(f: assign)
        fe(holders)
        
        XCTAssertEqual(int1, 1)
        XCTAssertEqual(int2, 2)
    }
    
    func testFreeFuncDefaultSortedBy() {
        let array: [Company] = [Company(name: "LithoByte, Co."), Company(name: "Aardvark, Inc."), Company(name: nil)]
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
    
    func testGet() {
        let arr = [0, 1]
        XCTAssertNotNil(get(index: 0, array: arr))
        XCTAssertNil(get(index: 2, array: arr))
        XCTAssertEqual(get(index: 0, array: arr)!, 0)
    }
    
    func testGetOperator() {
        let arr = [0, 1]
        let getter = ^arr
        XCTAssertNotNil(getter(0))
        XCTAssertNil(getter(2))
        XCTAssertEqual(getter(1)!, 1)
    }
    
    func testIndex() {
        let arr = [0, 1]
        let indexer = LithoOperators.index(array: arr)
        XCTAssertNotNil(indexer(0))
        XCTAssertNil(indexer(2))
        XCTAssertEqual(indexer(0)!, 0)
    }
    
    func testSomeSatisfy() {
        let arr1 = [0, 3]
        XCTAssertTrue(arr1 |> someSatisfy(f: isEqualTo(3)))
        let arr2 = [0, 1]
        XCTAssertFalse(arr2 |> someSatisfy(f: isEqualTo(3)))
    }
    
    func testAllSatisfy() {
        let arr1 = [3, 3]
        XCTAssertTrue(arr1 |> allSatisfy(f: isEqualTo(3)))
        let arr2 = [0, 3]
        XCTAssertFalse(arr2 |> allSatisfy(f: isEqualTo(3)))
    }
}
