//
//  Async.swift
//  caliUITests
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import XCTest

class TestUtils {
    static func check(app: XCUIApplication, viewIdentifier: String) {
        let view = app.otherElements[viewIdentifier]

        eventually(timeout: 2.0, check: { () -> Bool in
            view.exists
        }) { (result) in
            XCTAssert(result, "could not find view with identifier \(viewIdentifier)")
        }
    }
    
    static func wait(app: XCUIApplication, element: XCUIElement) {
        eventually(timeout: 2.0, check: { () -> Bool in
            element.exists
        }) { (result) in
            XCTAssert(result, "could not find view")
        }
    }
    /**
     Checks for a condition repeatly, either resolve it if it becomes true within timeout, or fail it
     
     - parameter timeout: time out to use
     - parameter check: condition to check
     - parameter closure: passes true condition resolves, false if time out
     */
    private static func eventually(timeout: TimeInterval = 2.0, check: () -> Bool, closure: (Bool) -> Void ) {
        var elapsed = 0.0
        let interval = 0.2
        
        while(true) {
            let result = check()
            if result {
                // Matching
                closure(true)
                break
            } else {
                if elapsed >= timeout {
                    closure(false)
                    break
                }
                let _ = check()
                elapsed += interval
            }
            
            Thread.sleep(forTimeInterval: interval)
        }
    }

}
