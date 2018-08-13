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
    }
    
    var plusButton : XCUIElement {
        return app.buttons.matching(identifier: AccessibilityIdentifier.plusButton).firstMatch
    }
    
    var eventCell : XCUIElement {
        return app.tables.cells.matching(identifier: AccessibilityIdentifier.eventCell).firstMatch
    }
    
    var eventTableView : XCUIElement {
        return app.tables.matching(identifier: AccessibilityIdentifier.eventTableView).firstMatch
    }
    
    var calendarButton : XCUIElement {
        return app.buttons.matching(identifier: AccessibilityIdentifier.calendarButton).firstMatch
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
    
    func scrollDownEvents() -> Self {
        eventTableView.swipeDown()
        return self
    }
    
    func pressCalendarButton() -> Self {
        calendarButton.tap()
        return self
    }
}
