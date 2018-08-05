//
//  CreateEventTextInputCell.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class EventTextInputCell: UITableViewCell {
    static let identifier = "EventTextInputCell"
    
    private let textField = UITextField()
    private let iconImageView = UIImageView()
    private let wrapper = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView() {
        wrapper.addSubview(textField)
        wrapper.addSubview(iconImageView)
        contentView.addSubview(wrapper)
        
        layout(wrapper)
            .direction(.Horizontal)
            .alignItems(.Center)
            .stack([
                layout(iconImageView),
                layout(textField)
                ])
            .install()
        
        layout(wrapper).matchParent().height(42).left(12).right(12).install()
    }
}
