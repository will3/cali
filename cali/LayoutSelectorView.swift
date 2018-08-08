//
//  LayoutSelectorView.swift
//  cali
//
//  Created by will3 on 9/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class LayoutSelectorView : UIView {
    var didLoad = false
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            if !didLoad {
                loadView()
                didLoad = true
            }
        }
    }
    
    let agendaView = RowView()
    let dayView = RowView()
    
    func loadView() {
        agendaView.showSeparator = true
        agendaView.label.text = NSLocalizedString("Agenda", comment: "")
        dayView.label.text = NSLocalizedString("Day", comment: "")
        
        layout(self).stack([
            layout(agendaView).height(preferredRowHeight),
            layout(dayView).height(preferredRowHeight)
            ]).install()
        
        backgroundColor = UIColor.white
    }
    
    let preferredRowHeight : Float = 60
    var preferredHeight : Float {
        return preferredRowHeight * 2
    }
    
    class RowView : UIView {
        var didLoad = false
        let iconView = UIImageView()
        let label = UILabel()
        let separator = UIView()
        
        var showSeparator = false {
            didSet {
                updateSeparator()
            }
        }
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            if superview != nil {
                if !didLoad {
                    loadView()
                    didLoad = true
                }
            }
        }
        
        func loadView() {
            layout(self).stackHorizontal([
                layout(iconView).width(44).height(44),
                layout(label)
                ]).install()
            
            separator.backgroundColor = Colors.separator
            layout(separator).pinLeft().pinRight().pinBottom().height(1).install()
            updateSeparator()
        }
        
        private func updateSeparator() {
            separator.isHidden = !showSeparator
        }
    }
}
