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

class MonthOverlayCell : UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    let label = UILabel()
    
    func loadView() {
        backgroundColor = UIColor.clear
        addSubview(label)
        layout(label).center().install()
        contentView.backgroundColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 0.8)
    }
    
    static let identifier = "MonthOverlayCell"
}
