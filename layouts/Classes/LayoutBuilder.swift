//
//  LayoutBuilder.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

public protocol LayoutWrapper {
    func layout_internal_getLayout() -> Layout
}

extension UIView : LayoutWrapper {
    public func layout_internal_getLayout() -> Layout {
        return Layout(view: self)
    }
}

public class LayoutBuilder : LayoutWrapper {
    let layout: Layout
    
    init (view: UIView) {
        layout = Layout(view: view)
    }
    
    public func layout_internal_getLayout() -> Layout {
        return layout
    }
    
    public func stack(_ wrappers: [LayoutWrapper]) -> Self {
        layout.stackChildren = true
        for wrapper in wrappers {
            layout.addChild(child: wrapper.layout_internal_getLayout())
        }
        return self
    }
    
    public func stackHorizontal(_ wrappers: [LayoutWrapper]) -> Self {
        return stack(wrappers).direction(.horizontal)
    }
    
    public func stackVertical(_ wrappers: [LayoutWrapper]) -> Self {
        return stack(wrappers)
    }
    
    public func width(_ width: LayoutSize) -> Self {
        layout.width = width
        return self
    }
    
    public func width(_ width: Float) -> Self {
        layout.width = .value(width)
        return self
    }
    
    public func minWidth(_ minWidth: LayoutSize) -> Self {
        layout.minWidth = minWidth
        return self
    }
    
    public func minWidth(_ minWidth: Float) -> Self {
        layout.minWidth = .value(minWidth)
        return self
    }
    
    public func maxWidth(_ maxWidth: LayoutSize) -> Self {
        layout.maxWidth = maxWidth
        return self
    }
    
    public func maxWidth(_ maxWidth: Float) -> Self {
        layout.maxWidth = .value(maxWidth)
        return self
    }
    
    public func height(_ height: LayoutSize) -> Self {
        layout.height = height
        return self
    }
    
    public func height(_ height: Float) -> Self {
        layout.height = .value(height)
        return self
    }
    
    public func minHeight(_ minHeight: LayoutSize) -> Self {
        layout.minHeight = minHeight
        return self
    }
    
    public func minHeight(_ minHeight: Float) -> Self {
        layout.minHeight = .value(minHeight)
        return self
    }
    
    public func maxHeight(_ maxHeight: LayoutSize) -> Self {
        layout.maxHeight = maxHeight
        return self
    }
    
    public func maxHeight(_ maxHeight: Float) -> Self {
        layout.maxHeight = .value(maxHeight)
        return self
    }
    
    public func direction(_ direction: LayoutDirection) -> Self {
        layout.direction = direction
        return self
    }
    
    public func alignItems(_ alignItems: LayoutFit) -> Self {
        layout.alignItems = alignItems
        return self
    }
    
    public func useTopMarginGuide(_ flag: Bool) -> Self {
        layout.useTopMarginGuide = flag
        return self
    }
    
    public func useBottomMarginGuide(_ flag: Bool) -> Self {
        layout.useBottomMarginGuide = flag
        return self
    }
    
    public func horizontal(_ fit: LayoutFit) -> Self {
        layout.fitHorizontal = fit
        return self
    }
    
    public func vertical(_ fit: LayoutFit) -> Self {
        layout.fitVertical = fit
        return self
    }
    
    public func aspect(_ value: Float) -> Self {
        layout.aspect = value
        return self
    }
    
    public func left(_ value: Float) -> Self {
        layout.insets.left = CGFloat(value)
        return self
    }
    
    public func right(_ value: Float) -> Self {
        layout.insets.right = CGFloat(value)
        return self
    }
    
    public func top(_ value: Float) -> Self {
        layout.insets.top = CGFloat(value)
        return self
    }
    
    public func bottom(_ value: Float) -> Self {
        layout.insets.bottom = CGFloat(value)
        return self
    }
    
    public func center() -> Self {
        return horizontal(.center).vertical(.center)
    }
    
    public func center(_ view: UIView) -> Self {
        return parent(view).center()
    }
    
    public func parent(_ view: UIView) -> Self {
        layout.parentView = view
        return self
    }
    
    public func matchParent() -> Self {
        return horizontal(.stretch).vertical(.stretch)
    }
    
    public func matchParent(_ view: UIView) -> Self {
        return parent(view).matchParent()
    }
    
    public func insets(_ insets: UIEdgeInsets) -> Self {
        layout.insets = insets
        return self
    }
    
    public func translatesAutoresizingMaskIntoConstraints() -> Self {
        layout.translatesAutoresizingMaskIntoConstraints = true
        return self
    }
    
    public func hugMore() -> Self {
        return hugMore(1)
    }
    
    public func hugMore(_ value: Float) -> Self {
        layout.hug = .more(value)
        return self
    }
    
    public func hugLess() -> Self {
        return hugLess(1)
    }
    
    public func hugLess(_ value: Float) -> Self {
        layout.hug = .less(value)
        return self
    }
    
    public func hug(_ value: Float) -> Self {
        layout.hug = .value(value)
        return self
    }
    
    public func resistMore() -> Self {
        return resistMore(1)
    }
    
    public func resistMore(_ value: Float) -> Self {
        layout.resist = .more(value)
        return self
    }
    
    public func resistLess() -> Self {
        return resistLess(1)
    }
    
    public func resistLess(_ value: Float) -> Self {
        layout.resist = .less(value)
        return self
    }
    
    public func resist(_ value: Float) -> Self {
        layout.resist = .value(value)
        return self
    }
    
    public func priority(_ value: Float) -> Self {
        return priority(UILayoutPriority(value))
    }
    
    public func priority(_ priority: UILayoutPriority) -> Self {
        layout.priority = priority
        return self
    }
    
    private var pinLeftValue: Float?
    private var pinRightValue: Float?
    private var pinTopValue: Float?
    private var pinBotValue: Float?
    
    public func pinLeft() -> Self {
        return pinLeft(0)
    }
    
    public func pinLeft(_ value: Float) -> Self {
        pinLeftValue = value
        return self
    }
    
    public func pinRight() -> Self {
        return pinRight(0)
    }
    
    public func pinRight(_ value: Float) -> Self {
        pinRightValue = value
        return self
    }
    
    public func pinTop() -> Self {
        return pinTop(0)
    }
    
    public func pinTop(_ value: Float) -> Self {
        pinTopValue = value
        return self
    }
    
    public func pinBottom() -> Self {
        return pinBottom(0)
    }
    
    public func pinBottom(_ value: Float) -> Self {
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
    
    public func justifyItems(_ value: LayoutJustify) -> Self {
        layout.justifyItems = value
        return self
    }
    
    public func install() {
        updatePins()
        layout.install()
    }
    
    public func reinstall() {
        install()
    }
    
    public func uninstall() {
        layout.uninstall()
    }
}
