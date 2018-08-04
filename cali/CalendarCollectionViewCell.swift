//
//  CalendarCollectionViewCell.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    var label: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        label = UILabel(frame: contentView.bounds)
        label.textAlignment = .center
        contentView.addSubview(label)
        
        Layouts.item(label).center().install()
    }
}
