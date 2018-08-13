//
//  Accessability.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class AccessibilityIdentifier {
    static let mainView = "mainView"
    static let createEventView = "createEventView"
    
    static let plusButton = "plusButton"
    static let titleInput = "titleInput"
    static let tickButton = "tickButton"
    static let crossButton = "crossButton"
    static let eventCell = "eventCell"
    static let eventListView = "eventListView"
    static let eventTableView = "eventTableView"
    static let todayButton = "todayButton"
    
    /// Add accessibility identifier to view controller
    static func set(viewController: UIViewController, identifier: String) {
        let accessibilityView = UIView()
        accessibilityView.backgroundColor = UIColor.white
        viewController.view.addSubview(accessibilityView)
        accessibilityView.isAccessibilityElement = true
        accessibilityView.accessibilityIdentifier = identifier
        
        accessibilityView.frame = viewController.view.bounds
        accessibilityView.translatesAutoresizingMaskIntoConstraints = true
        accessibilityView.superview?.sendSubview(toBack: accessibilityView)
    }
}
