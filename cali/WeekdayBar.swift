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
    var loaded = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        if !loaded {
            loadViews()
            loaded = true
        }
    }
    
    func loadViews() {
        let days = [ "S", "M", "T", "W", "T", "F", "S" ]
        for i in 0..<7 {
            let label = UILabel()
            labels.append(label)
            label.font = Fonts.weekdayFont
            label.textColor = Colors.primary
            label.textAlignment = .center
            addSubview(label)
            
            label.text = days[i];
        }
        
        layout(self)
            .direction(.Horizontal)
            .stack(labels.map({ label in
                return layout(label).width(.Ratio(1 / 7.0))
            })).install()
        
        let border = UIView()
        addSubview(border)
        border.backgroundColor = Colors.separator
        
        layout(border).horizontal(.Stretch).vertical(.Trailing).height(1.0).install()
    }
}
