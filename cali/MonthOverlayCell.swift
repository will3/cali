//
//  MonthOverlayCell.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

/// Month overlay cell
class MonthOverlayCell : UITableViewCell {
    static let identifier = "MonthOverlayCell"
    let label = UILabel()
    
    private var loaded = false
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            if !loaded {
                loaded = true
                loadView()
            }
        }
    }
    
    func loadView() {
        backgroundColor = UIColor.clear
        addSubview(label)
        layout(label).center().install()
        contentView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
    }
}
