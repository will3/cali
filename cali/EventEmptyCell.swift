//
//  EventCell.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventEmptyCell : UITableViewCell {
    private let noEventsLabel = UILabel()
    
    static let identifier = "EventEmptyCell"

    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView() {
        noEventsLabel.text = NSLocalizedString("No events", comment: "")
        contentView.addSubview(noEventsLabel)
        noEventsLabel.textColor = Colors.primary
        noEventsLabel.font = Fonts.fontMedium
        
        layout(noEventsLabel)
            .horizontal(.stretch)
            .left(18)
            .right(18)
            .vertical(.stretch)
            .top(12)
            .bottom(12)
            .install()
    }
}
