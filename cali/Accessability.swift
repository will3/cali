//
//  Accessability.swift
//  cali
//
//  Created by will3 on 12/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

enum AccessibilityIdentifier : String {
    case mainView = "mainView"
    case createEventView = "createEventView"
    
    case plusButton = "plusButton"
    case titleInput = "titleInput"
    case tickButton = "tickButton"
    case crossButton = "crossButton"
    case eventCell = "eventCell"
    case eventListView = "eventListView"
    case eventTableView = "eventTableView"
    case calendarButton = "calendarButton"
    
    /// Add accessibility identifier to view controller
    func set(viewController: UIViewController) {
        let accessibilityView = UIView()
        accessibilityView.backgroundColor = UIColor.white
        viewController.view.addSubview(accessibilityView)
        accessibilityView.isAccessibilityElement = true
        accessibilityView.accessibilityIdentifier = rawValue
        
        accessibilityView.frame = viewController.view.bounds
        accessibilityView.translatesAutoresizingMaskIntoConstraints = true
        accessibilityView.superview?.sendSubview(toBack: accessibilityView)
    }
}
