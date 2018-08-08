//
//  EventCell.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class EventEmptyCell : UITableViewCell {
    var noEventsLabel: UILabel?
    
    static var identifier: String {
        return "EventEmptyCell"
    }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func loadView() {
        let noEventsLabel = UILabel()
        noEventsLabel.text = NSLocalizedString("No events", comment: "")
        contentView.addSubview(noEventsLabel)
        noEventsLabel.textColor = Colors.primary
        
        layout(noEventsLabel)
            .horizontal(.stretch)
            .left(18)
            .right(18)
            .vertical(.stretch)
            .top(12)
            .bottom(12)
            .install()
        
        self.noEventsLabel = noEventsLabel
    }
}
