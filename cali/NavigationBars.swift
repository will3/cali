//
//  NavigationBars.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class NavigationBars {
    enum Style {
        case white
    }
    
    static func style(navigationBar: UINavigationBar, _ style: Style) {
        switch style {
        case .white:
            navigationBar.isTranslucent = false
            navigationBar.barTintColor = UIColor.white
            navigationBar.setBackgroundImage(UIImage(), for: .default)
            navigationBar.shadowImage = UIImage()
        }
    }
}
