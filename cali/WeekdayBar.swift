//
//  WeekdayBar.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class WeekdayBar: UIView {
    var labels : [UILabel] = [];
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initSubviews()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initSubviews()
    }
    
    func initSubviews() {
        let days = [ "S", "M", "T", "W", "T", "F", "S" ]
        for i in 0..<7 {
            let label = UILabel()
            labels.append(label)
            addSubview(label)
            
            label.text = days[i];
            
            if i == 0 {
                label.leftAnchor.constraint(equalTo: self.leftAnchor);
            } else {
                label.leftAnchor.constraint(equalTo: labels[i - 1].rightAnchor);
            }
            label.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 1 / 7.0);
        }
    }
}
