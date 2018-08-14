//
//  Accessability.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

/// Accessibility identifier
class AccessibilityIdentifier {

    /// Main view
    static let mainView = "mainView"

    /// Create event view
    static let createEventView = "createEventView"
    
    /// Plus button
    static let plusButton = "plusButton"

    /// Title input
    static let titleInput = "titleInput"

    /// Tick button
    static let tickButton = "tickButton"

    /// Cross button
    static let crossButton = "crossButton"

    /// Event cell
    static let eventCell = "eventCell"

    /// Event list view
    static let eventListView = "eventListView"

    /// Event table view
    static let eventTableView = "eventTableView"

    /// Today button
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
