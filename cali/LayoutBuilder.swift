//
//  LayoutBuilder.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

protocol LayoutWrapper {
    func layout_internal_getLayout() -> Layout
}

extension UIView : LayoutWrapper {
    func layout_internal_getLayout() -> Layout {
        return Layout(view: self)
    }
}

class LayoutBuilder : LayoutWrapper {
    let layout: Layout
    
    init (view: UIView) {
        layout = Layout(view: view)
    }
    
    func layout_internal_getLayout() -> Layout {
        return layout
    }
    
    func stack(_ wrappers: [LayoutWrapper]) -> Self {
        layout.stackChildren = true
        for wrapper in wrappers {
            layout.addChild(child: wrapper.layout_internal_getLayout())
        }
        return self
    }
    
    func stackHorizontal(_ wrappers: [LayoutWrapper]) -> Self {
        return stack(wrappers).direction(.horizontal)
    }
    
    func stackVertical(_ wrappers: [LayoutWrapper]) -> Self {
        return stack(wrappers)
    }
    
    func width(_ width: LayoutSize) -> Self {
        layout.width = width
        return self
    }
    
    func width(_ width: Float) -> Self {
        layout.width = .value(width)
        return self
    }
    
    func minWidth(_ minWidth: LayoutSize) -> Self {
        layout.minWidth = minWidth
        return self
    }
    
    func minWidth(_ minWidth: Float) -> Self {
        layout.minWidth = .value(minWidth)
        return self
    }
    
    func maxWidth(_ maxWidth: LayoutSize) -> Self {
        layout.maxWidth = maxWidth
        return self
    }
    
    func maxWidth(_ maxWidth: Float) -> Self {
        layout.maxWidth = .value(maxWidth)
        return self
    }
    
    func height(_ height: LayoutSize) -> Self {
        layout.height = height
        return self
    }
    
    func height(_ height: Float) -> Self {
        layout.height = .value(height)
        return self
    }
    
    func minHeight(_ minHeight: LayoutSize) -> Self {
        layout.minHeight = minHeight
        return self
    }
    
    func minHeight(_ minHeight: Float) -> Self {
        layout.minHeight = .value(minHeight)
        return self
    }
    
    func maxHeight(_ maxHeight: LayoutSize) -> Self {
        layout.maxHeight = maxHeight
        return self
    }
    
    func maxHeight(_ maxHeight: Float) -> Self {
        layout.maxHeight = .value(maxHeight)
        return self
    }
    
    func direction(_ direction: LayoutDirection) -> Self {
        layout.direction = direction
        return self
    }
    
    func alignItems(_ alignItems: LayoutFit) -> Self {
        layout.alignItems = alignItems
        return self
    }
    
    func useTopMarginGuide(_ flag: Bool) -> Self {
        layout.useTopMarginGuide = flag
        return self
    }
    
    func useBottomMarginGuide(_ flag: Bool) -> Self {
        layout.useBottomMarginGuide = flag
        return self
    }
    
    func horizontal(_ fit: LayoutFit) -> Self {
        layout.fitHorizontal = fit
        return self
    }
    
    func vertical(_ fit: LayoutFit) -> Self {
        layout.fitVertical = fit
        return self
    }
    
    func aspect(_ value: Float) -> Self {
        layout.aspect = value
        return self
    }
    
    func left(_ value: Float) -> Self {
        layout.insets.left = CGFloat(value)
        return self
    }
    
    func right(_ value: Float) -> Self {
        layout.insets.right = CGFloat(value)
        return self
    }
    
    func top(_ value: Float) -> Self {
        layout.insets.top = CGFloat(value)
        return self
    }
    
    func bottom(_ value: Float) -> Self {
        layout.insets.bottom = CGFloat(value)
        return self
    }
    
    func center() -> Self {
        return horizontal(.center).vertical(.center)
    }
    
    func center(_ view: UIView) -> Self {
        return parent(view).center()
    }
    
    func parent(_ view: UIView) -> Self {
        layout.parentView = view
        return self
    }
    
    func matchParent() -> Self {
        return horizontal(.stretch).vertical(.stretch)
    }
    
    func matchParent(_ view: UIView) -> Self {
        return parent(view).matchParent()
    }
    
    func insets(_ insets: UIEdgeInsets) -> Self {
        layout.insets = insets
        return self
    }
    
    func translatesAutoresizingMaskIntoConstraints() -> Self {
        layout.translatesAutoresizingMaskIntoConstraints = true
        return self
    }
    
    func hugMore() -> Self {
        return hugMore(1)
    }
    
    func hugMore(_ value: Float) -> Self {
        layout.hug = .more(value)
        return self
    }
    
    func hugLess() -> Self {
        return hugLess(1)
    }
    
    func hugLess(_ value: Float) -> Self {
        layout.hug = .less(value)
        return self
    }
    
    func hug(_ value: Float) -> Self {
        layout.hug = .value(value)
        return self
    }
    
    func resistMore() -> Self {
        return resistMore(1)
    }
    
    func resistMore(_ value: Float) -> Self {
        layout.resist = .more(value)
        return self
    }
    
    func resistLess() -> Self {
        return resistLess(1)
    }
    
    func resistLess(_ value: Float) -> Self {
        layout.resist = .less(value)
        return self
    }
    
    func resist(_ value: Float) -> Self {
        layout.resist = .value(value)
        return self
    }
    
    func priority(_ value: Float) -> Self {
        return priority(UILayoutPriority(value))
    }
    
    func priority(_ priority: UILayoutPriority) -> Self {
        layout.priority = priority
        return self
    }
    
    private var pinLeftValue: Float?
    private var pinRightValue: Float?
    private var pinTopValue: Float?
    private var pinBotValue: Float?
    
    func pinLeft() -> Self {
        return pinLeft(0)
    }
    
    func pinLeft(_ value: Float) -> Self {
        pinLeftValue = value
        return self
    }
    
    func pinRight() -> Self {
        return pinRight(0)
    }
    
    func pinRight(_ value: Float) -> Self {
        pinRightValue = value
        return self
    }
    
    func pinTop() -> Self {
        return pinTop(0)
    }
    
    func pinTop(_ value: Float) -> Self {
        pinTopValue = value
        return self
    }
    
    func pinBottom() -> Self {
        return pinBottom(0)
    }
    
    func pinBottom(_ value: Float) -> Self {
        pinBotValue = value
        return self
    }
    
    private func updatePins() {
        if pinLeftValue != nil && pinRightValue != nil {
            layout.fitHorizontal = .stretch
        } else if pinLeftValue != nil {
            layout.fitHorizontal = .leading
        } else if pinRightValue != nil {
            layout.fitHorizontal = .trailing
        }
        
        if (pinTopValue != nil && pinBotValue != nil) {
            layout.fitVertical = .stretch
        } else if pinTopValue != nil {
            layout.fitVertical = .leading
        } else if pinBotValue != nil {
            layout.fitVertical = .trailing
        }
        
        if let pinLeftValue = self.pinLeftValue {
            layout.insets.left = CGFloat(pinLeftValue)
        }
        
        if let pinRightValue = self.pinRightValue {
            layout.insets.right = CGFloat(pinRightValue)
        }
        
        if let pinTopValue = self.pinTopValue {
            layout.insets.top = CGFloat(pinTopValue)
        }
        
        if let pinBotValue = self.pinBotValue {
            layout.insets.bottom = CGFloat(pinBotValue)
        }
    }
    
    func install() {
        updatePins()
        layout.install()
    }
    
    func reinstall() {
        layout.install()
    }
    
    func uninstall() {
        layout.uninstall()
    }
}
