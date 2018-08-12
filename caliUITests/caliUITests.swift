//
//  caliUITests.swift
//  caliUITests
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import XCTest

class caliUITests: XCTestCase {
        
    override func setUp() {
        super.setUp()
        
        // Put setup code here. This method is called before the invocation of each test method in the class.
        
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false
        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        
        let app = XCUIApplication()
        app.launchEnvironment = [ "isUITest": "true" ]
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
//    func testCreateEvent() {
//        let app = XCUIApplication()
//
//        let _ = MainView(app: app)
//            .createEvent()
//            .save()
//    }
//
//    func testDiscardEvent() {
//
//        let app = XCUIApplication()
//
//        let _ = MainView(app: app)
//            .createEvent()
//            .discard()
//    }
    
    func testCreateEventAndOpen() {
        let app = XCUIApplication()
        
        let _ = MainView(app: app)
            .createEvent()
            .save()
            .openEvent()
    }
}
