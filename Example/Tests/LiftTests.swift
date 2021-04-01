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
    
    func testSet() {
        let view = UIView()
        let setBackgroundBlack: (UIView) -> Void = set(\UIView.backgroundColor, .black)
        setBackgroundBlack(view)
        XCTAssert(view.backgroundColor == .black)
    }
    
    func testSetter() {
        let view = UIView()
        let setBackground = setter(\UIView.backgroundColor)
        setBackground(view, .black)
        XCTAssertEqual(view.backgroundColor, .black)
    }
    
    func testWritableInoutLift() {
        struct User {
            var name: String
        }
        var user = User(name: "Calvin")
        let screemName: (inout User, WritableKeyPath<User, String>) -> Void = {
            (^$1) { val in
                val += "!"
            }(&$0)
        }
        
        screemName(&user, \User.name)
        XCTAssert(user.name == "Calvin!")
    }
    
    func testEscapingLift() {
        struct User {
            var name: String
        }
        var user = User(name: "Calvin")
        let screemName: (WritableKeyPath<User, String>) -> (User) -> User = {
            ((^$0) { $0 + "!" })
        }
        
        let newUser = (screemName(\User.name))(user)
        
        XCTAssert(newUser.name == "Calvin!")
        
    }
}
