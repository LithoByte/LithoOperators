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
    
    func testFreeFuncMap() {
        XCTAssertEqual(map(array: coArray, f: { (co: Company) in return co.name }), stringArray)
    }
    
    func testFreeKeyPathCompactMap() {
        let nilNameCoArray = coArray + [Company(name: nil)]
        XCTAssertEqual(compactMap(array: nilNameCoArray, \Company.name), stringArray)
    }
    
    func testFreeFuncCompactMap() {
        let nilNameCoArray = coArray + [Company(name: nil)]
        XCTAssertEqual(compactMap(array: nilNameCoArray, f: { (co: Company) in return co.name }), stringArray)
    }
}
