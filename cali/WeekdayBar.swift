//
//  WeekdayBar.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit
import Layouts

/// Week day bar
class WeekdayBar: UIView {
    let preferredHeight : Float = 28

    /// Labels
    private var labels : [UILabel] = [];
    /// View loaded
    private var loaded = false
    
    override func didMoveToSuperview() {
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    private func loadView() {
        backgroundColor = Colors.white
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
        
        let children = labels.map { (label) in
            return layout(label).width(.ratio(1 / 7.0)).priority(999)
        }
        
        layout(self)
            .direction(.horizontal)
            .stack(children)
            .install()
        
        let border = UIView()
        addSubview(border)
        border.backgroundColor = Colors.separator
        
        layout(border)
            .horizontal(.stretch)
            .vertical(.trailing)
            .height(1.0)
            .install()
        
        layout(self).height(preferredHeight).priority(999).install()
    }
}
