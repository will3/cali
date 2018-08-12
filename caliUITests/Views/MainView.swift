//
//  MainPage.swift
//  caliUITests
//
//  Created by will3 on 11/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import XCTest

enum UITestError {
    case viewNotFound(String)
}

class MainView {
    var app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
        TestUtils.check(app: app, viewIdentifier: ViewIdentifier.mainView)
    }
    
    var plusButton : XCUIElement {
        return app.buttons.matching(identifier: ViewIdentifier.plusButton).firstMatch
    }
    
    var eventCell : XCUIElement {
        let label = "Untitled"
        app.otherElements
        return app.cells.containing(NSPredicate(format: "label CONTAINS %@", label)).firstMatch
    }
    
    func createEvent() -> CreateEventView {
        plusButton.tap()
        return CreateEventView(app: app)
    }
    
    // Open any event
    func openEvent() -> CreateEventView {
        eventCell.tap()
        return CreateEventView(app: app)
    }
}
