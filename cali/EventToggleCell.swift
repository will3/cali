//
//  CreateEventCell.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventToggleCell : UITableViewCell {
    static let identifier = "EventToggleCell"
    private let label = UILabel()
    private let iconImageView = UIImageView()
    private let wrapper = UIView()
    private var loaded = false
    
    var title = "" { didSet { updateTitle() } }
    var icon: UIImage? { didSet { updateIcon() }}

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if self.superview != nil {
            if !loaded {
                loadView()
                loaded = true
            }
        }
    }
    
    func loadView() {
        contentView.addSubview(wrapper)
        wrapper.addSubview(label)
        wrapper.addSubview(iconImageView)
        
        layout(wrapper)
            .direction(.horizontal)
            .alignItems(.center)
            .stack([
                layout(label),
                layout(iconImageView)
                ]).install()
        
        layout(wrapper)
            .height(42)
            .left(12)
            .right(12)
            .matchParent()
            .install()
    }
    
    func updateTitle() {
        label.text = title
    }
    
    func updateIcon() {
        iconImageView.image = icon
    }
}
