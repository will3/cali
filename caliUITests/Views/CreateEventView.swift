//
//  CreateEventView.swift
//  caliUITests
//
//  Created by will3 on 11/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import XCTest

class CreateEventView {
    var app: XCUIApplication
    init(app: XCUIApplication) {
        self.app = app
        XCTAssert(app.otherElements.matching(identifier: AccessibilityIdentifier.createEventView).count > 0)
    }
    
    var tickButton : XCUIElement {
        return app.buttons.matching(identifier: AccessibilityIdentifier.tickButton).firstMatch
    }
    
    var crossButton : XCUIElement {
        return app.buttons.matching(identifier: AccessibilityIdentifier.crossButton).firstMatch
    }
    
    func save() -> MainView {
        tickButton.tap()
        return MainView(app: app)
    }
    
    func discard() -> MainView {
        crossButton.tap()
        
        let actionSheet = app.sheets.firstMatch
        
        actionSheet.buttons.firstMatch.tap()

        return MainView(app: app)
    }
}
