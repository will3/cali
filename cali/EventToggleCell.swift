//
//  CreateEventCell.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class EventToggleCell : UITableViewCell {
    static let identifier = "EventToggleCell"
    private let label = UILabel()
    private let iconImageView = UIImageView()
    private let wrapper = UIView()
    
    var title = "" { didSet { updateTitle() } }
    var icon: UIImage? { didSet { updateIcon() }}
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
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
