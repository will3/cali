//
//  EventHandleView.swift
//  cali
//
//  Created by will3 on 7/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventHandleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var loaded = false
    override func didMoveToSuperview() {
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    /// Circle view
    private let circle = UIView()
    
    func loadView() {
        circle.backgroundColor = Colors.white
        let size = Float(10)
        circle.layer.cornerRadius = CGFloat(size) / 2
        circle.clipsToBounds = true
        circle.layer.borderWidth = 1
        circle.layer.borderColor = Colors.accent.cgColor
        
        layout(circle)
            .width(size)
            .height(size)
            .center(self).install()
    }
}
