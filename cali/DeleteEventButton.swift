//
//  DeleteEventButton.swift
//  cali
//
//  Created by will3 on 11/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class DeleteEventButton : UIView {
    let preferredHeight: Float = 44
    let button = UIButton()
    
    private var loaded = false
    private let label = UILabel()
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    private func loadView() {
        layout(label).matchParent(self).left(20).right(20).install()
        layout(self).height(preferredHeight).priority(999).install()
        
        layer.borderColor = Colors.primary.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = CGFloat(preferredHeight / 2.0)
        clipsToBounds = true
        
        label.textColor = Colors.red
        label.font = Fonts.fontNormal
        label.text = NSLocalizedString("Delete event", comment: "")
        
        layout(button).matchParent(self).install()
        
        layer.masksToBounds = false
        
        layer.shadowOpacity = 0.04
        layer.shadowColor = Colors.black.cgColor
        layer.shadowRadius = 4
    }
}
