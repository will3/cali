//
//  CalendarAnimatedView.swift
//  cali
//
//  Created by will3 on 9/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class CalendarAnimatedView : UIView {
    var loaded = false
    
    var today = Date() { didSet { updateDay() } }
    var offset : CGFloat = 0 { didSet { updateDelta() } }
    let numberOfLeaves = 4
    var leafs : [ LeafView ] = []
    
    let button = UIButton()
    
    private func updateDay() {
        if let day = Calendar.current.dateComponents([.day], from: today).day {
            for leaf in leafs {
                leaf.day = day
            }
        }
    }
    
    let preferredWidth : CGFloat = 24
    let preferredHeight : CGFloat = 24
    
    private func updateDelta() {
        let delta = Float(offset)
        var index = 0
        for leaf in leafs {
            leaf.delta = delta
            index += 1
        }
        
        // Update tilt
        let maxTilt = CGFloat(8) * .pi / 180.0
        var tiltAmount = CGFloat(delta) / CGFloat(800)
        tiltAmount = min(1, max(tiltAmount, -1))
        
        let pivot = CGPoint(x: 0, y: -preferredHeight)
        
        let tilt = maxTilt * tiltAmount
        
        self.transform =
            CGAffineTransform.identity
                .translatedBy(x: -pivot.x, y: -pivot.y)
                .rotated(by: tilt)
                .translatedBy(x: pivot.x, y: pivot.y)
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if superview != nil {
            if !loaded {
                loadView()
                loaded = true
            }
        }
    }
    
    private func loadView() {
        for index in 0..<numberOfLeaves {
            let leaf = LeafView()
            leafs.append(leaf)
            leaf.translatesAutoresizingMaskIntoConstraints = false
            addSubview(leaf)
            leaf.index = numberOfLeaves - index - 1
        }
        
        layout(button).matchParent(self).install()
        
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        var index = 0
        for leaf in leafs {
            leaf.frame = CGRect(x: 0,
                                y: 0,
                                width: preferredWidth,
                                height: preferredHeight)
            index += 1
        }
    }
    
    class LeafView : UIView {
        var loaded = false
        
        var day = 1 {
            didSet {
                updateDay()
            }
        }
        
        var delta : Float = 0 { didSet {
            updateDelta() }}
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            if superview != nil {
                if !loaded {
                    loadView()
                    loaded = true
                }
            }
        }
        
        let imageView = UIImageView()
        let label = UILabel()
        var index = 0
        
        private func loadView() {
            imageView.image = Images.cal
            layout(imageView).matchParent(self).install()
            layout(label).parent(self).horizontal(.center).pinBottom(1.5).install()
            
            label.font = Fonts.fontSmall
            label.textColor = Colors.accent
            updateDay()
        }
        
        private func updateDay() {
            label.text = "\(day)"
        }
        
        private func updateDelta() {
            let offset = CGFloat(1) - CGFloat(index) / 3.0
            if index > 0 {
                let maxTilt = CGFloat(-20) * .pi / 180.0
                var amount = CGFloat(delta) / CGFloat(800)
                let ratio = pow(abs(amount), 0.5)
                
                amount += offset
                
                let sign = CGFloat(amount < 0 ? -1 : 1)
                
                if (ratio < 1) {
                    amount = amount * ratio
                }
                
                amount = amount.truncatingRemainder(dividingBy: 1.0)
                
                amount = pow(amount, 2.0) * sign
                
                let tilt = maxTilt * amount
                
                let maxLeft = CGFloat(-14)
                let left = maxLeft * amount
                
                let maxScale = CGFloat(0.5)
                let scale = abs(maxScale * amount)
                
                let maxAlpha = CGFloat(1.0)
                let alpha = abs(maxAlpha * pow(amount, 2))
                
                let maxUp = CGFloat(-4.0)
                let up = maxUp * abs(amount)
                
                self.transform =
                    CGAffineTransform.identity
                        .rotated(by: tilt)
                        .translatedBy(x: left, y: up)
                        .scaledBy(x: 1 - scale, y: 1 - scale)
                
                self.alpha = 1 - alpha
            }
        }
    }
}
