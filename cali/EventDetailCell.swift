//
//  EventDetailCell.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class EventDetailCell: UITableViewCell {
    static let identifier = "EventDetailCell"
    let iconImageView = UIImageView()
    let titleLabel = UILabel()
    let detailLabel = UILabel()
    let wrapper = UIView()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView() {
        layout(wrapper)
            .alignItems(.Center)
            .stack([
                layout(iconImageView),
                layout(titleLabel),
                layout(detailLabel)
            ]).install()
    }
}
