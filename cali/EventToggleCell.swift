//
//  EventToggleCell.swift
//  cali
//
//  Created by will3 on 13/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventToggleCell : UITableViewCell {
    var loaded = false
    let titleLabel = UILabel()
    let toggle = UISwitch()
    static let identifier = "EventToggleCell"
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            if !loaded {
                loadView()
                loaded = true
            }
        }
    }
    
    private func loadView() {
        layout(titleLabel)
            .parent(contentView)
            .height(42)
            .pinLeft(12)
            .vertical(.stretch)
            .install()
        
        layout(toggle)
            .parent(contentView)
            .pinRight(12)
            .vertical(.center)
            .install()
        
        toggle.tintColor = Colors.primary
        toggle.onTintColor = Colors.accent
        
        selectionStyle = .none
    }
}
