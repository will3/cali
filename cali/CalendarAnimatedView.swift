//
//  TodayButton.swift
//  cali
//
//  Created by will3 on 9/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

/// Today button
class TodayButton : UIView {
    /// Today, setting this updates the view
    var today : Date = {
        let now = Injection.defaultContainer.nowProvider.now
        return now
    }() { didSet { updateDay() } }
    
    /// offset in pixels, set this to animate the view
    var offset : CGFloat = 0 { didSet { updateDelta() } }
    /// Tappable area
    let button = UIButton()
    /// View loaded
    private var loaded = false
    /// Number of leaves
    private let numberOfLeaves = 4
    /// Leaves
    private var leafs : [ LeafView ] = []
    /// Calendar
    private let calendar = Injection.defaultContainer.calendar
    /// Day
    private var day: Int {
        if let day = calendar.dateComponents([.day], from: today).day {
            return day
        }
        return 0
    }
    /// Preferred width
    private let preferredWidth : Float = 24
    /// Preferred height
    private let preferredHeight : Float = 24
    
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
        
        let pivot = CGPoint(x: 0.0, y: -Double(preferredHeight))
        
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
        let day = self.day
        for index in 0..<numberOfLeaves {
            let leaf = LeafView()
            leafs.append(leaf)
            leaf.translatesAutoresizingMaskIntoConstraints = false
            addSubview(leaf)
            
            layout(leaf)
                .width(preferredWidth)
                .height(preferredHeight)
                .center(self)
                .install()
            
            leaf.index = numberOfLeaves - index - 1
            
            if leaf.index == 0 {
                leaf.day = "\(day)"
            }
            leaf.isFront = leaf.index == 0
        }
        
        layout(button).matchParent(self).install()
        
        layoutIfNeeded()
    }
    
    private func updateDay() {
        let day = self.day
        for leaf in leafs {
            if leaf.index == 0 {
                leaf.day = "\(day)"
            }
        }
    }
    
    private class LeafView : UIView {

        var day = "" { didSet { updateDay() } }
        var delta : Float = 0 { didSet { updateDelta() } }
        var index = 0
        var isFront = false { didSet { updateImage() } }

        private var loaded = false
        private let imageView = UIImageView()
        private let label = UILabel()
        
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
            layout(imageView).matchParent(self).install()
            layout(label).parent(self).horizontal(.center).pinBottom(1.5).install()
            
            label.font = Fonts.fontMedium
            label.textColor = Colors.accent
            updateDay()
            updateImage()
            self.layer.shouldRasterize = true
            self.layer.rasterizationScale = UIScreen.main.scale
        }
        
        private func updateImage() {
            if isFront {
                imageView.image = Images.cal
            } else {
                imageView.image = Images.calLeaf
            }
        }

        private func updateDay() {
            label.text = day
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
                
                self.layer.zPosition = -abs(amount * 1000.0)
                
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
