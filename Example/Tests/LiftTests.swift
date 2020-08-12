//
//  LiftTests.swift
//  LithoOperators_Tests
//
//  Created by Elliot Schrock on 8/12/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import XCTest
import LithoOperators

class LiftTests: XCTestCase {
    func testLift() throws {
        let vc = UIViewController()
        let view = UIView()
        
        vc.view = view
        
        let function: (UIViewController) -> UIView? = ^\UIViewController.view
        
        XCTAssertEqual(function(vc), view)
    }
}
