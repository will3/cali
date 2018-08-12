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
        TestUtils.check(app: app, viewIdentifier: ViewIdentifier.createEventView)
    }
    
    var tickButton : XCUIElement {
        return app.buttons.matching(identifier: ViewIdentifier.tickButton).firstMatch
    }
    
    var crossButton : XCUIElement {
        return app.buttons.matching(identifier: ViewIdentifier.crossButton).firstMatch
    }
    
    func save() -> MainView {
        tickButton.tap()
        return MainView(app: app)
    }
    
    func discard() -> MainView {
        crossButton.tap()
        
        let actionSheet = app.sheets.firstMatch
        TestUtils.wait(app: app, element: actionSheet)
        actionSheet.buttons.firstMatch.tap()

        return MainView(app: app)
    }
}
