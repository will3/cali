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

/// Fluent interface for Layout
public class LayoutBuilder : LayoutWrapper {
    let layout: Layout
    
    init (view: UIView) {
        layout = Layout(view: view)
    }
    
    public func layout_internal_getLayout() -> Layout {
        return layout
    }
    
    /// Stack vertically
    public func stack(_ wrappers: [LayoutWrapper]) -> Self {
        layout.stackChildren = true
        for wrapper in wrappers {
            layout.addChild(child: wrapper.layout_internal_getLayout())
        }
        return self
    }
    
    /// Stack horizontally
    public func stackHorizontal(_ wrappers: [LayoutWrapper]) -> Self {
        return stack(wrappers).direction(.horizontal)
    }
    
    /// Stack vertically
    public func stackVertical(_ wrappers: [LayoutWrapper]) -> Self {
        return stack(wrappers)
    }
    
    /// Set width
    public func width(_ width: LayoutSize) -> Self {
        layout.width = width
        return self
    }
    
    /// Set width
    public func width(_ width: Float) -> Self {
        layout.width = .value(width)
        return self
    }
    
    /// Set min width
    public func minWidth(_ minWidth: LayoutSize) -> Self {
        layout.minWidth = minWidth
        return self
    }
    
    /// Set min width
    public func minWidth(_ minWidth: Float) -> Self {
        layout.minWidth = .value(minWidth)
        return self
    }
    
    /// Set max width
    public func maxWidth(_ maxWidth: LayoutSize) -> Self {
        layout.maxWidth = maxWidth
        return self
    }
    
    /// Set max width
    public func maxWidth(_ maxWidth: Float) -> Self {
        layout.maxWidth = .value(maxWidth)
        return self
    }
    
    /// Set height
    public func height(_ height: LayoutSize) -> Self {
        layout.height = height
        return self
    }
    
    /// Set height
    public func height(_ height: Float) -> Self {
        layout.height = .value(height)
        return self
    }
    
    /// Set min height
    public func minHeight(_ minHeight: LayoutSize) -> Self {
        layout.minHeight = minHeight
        return self
    }
    
    /// Set min height
    public func minHeight(_ minHeight: Float) -> Self {
        layout.minHeight = .value(minHeight)
        return self
    }
    
    /// Set max height
    public func maxHeight(_ maxHeight: LayoutSize) -> Self {
        layout.maxHeight = maxHeight
        return self
    }
    
    /// Set max height
    public func maxHeight(_ maxHeight: Float) -> Self {
        layout.maxHeight = .value(maxHeight)
        return self
    }
    
    /// Set stack direction
    public func direction(_ direction: LayoutDirection) -> Self {
        layout.direction = direction
        return self
    }
    
    /// Set align items
    public func alignItems(_ alignItems: LayoutFit) -> Self {
        layout.alignItems = alignItems
        return self
    }
    
    /// Use top margin guide
    public func useTopMarginGuide() -> Self {
        layout.useTopMarginGuide = true
        return self
    }
    
    /// Use bottom margin guide
    public func useBottomMarginGuide() -> Self {
        layout.useBottomMarginGuide = true
        return self
    }
    
    /// Specify horizontal fit
    public func horizontal(_ fit: LayoutFit) -> Self {
        layout.fitHorizontal = fit
        return self
    }
    
    /// Specify vertical fit
    public func vertical(_ fit: LayoutFit) -> Self {
        layout.fitVertical = fit
        return self
    }
    
    /// Set aspect
    public func aspect(_ value: Float) -> Self {
        layout.aspect = value
        return self
    }
    
    /// Set left margin
    public func left(_ value: Float) -> Self {
        layout.insets.left = CGFloat(value)
        return self
    }
    
    /// Set right margin
    public func right(_ value: Float) -> Self {
        layout.insets.right = CGFloat(value)
        return self
    }
    
    /// Set top margin
    public func top(_ value: Float) -> Self {
        layout.insets.top = CGFloat(value)
        return self
    }
    
    /// Set bottom margin
    public func bottom(_ value: Float) -> Self {
        layout.insets.bottom = CGFloat(value)
        return self
    }
    
    /// Center fit horizontally and vertically
    public func center() -> Self {
        return horizontal(.center).vertical(.center)
    }
    
    /// Center fit horizontally and vertically, in parent
    public func center(_ view: UIView) -> Self {
        return parent(view).center()
    }
    
    /// Set parent
    public func parent(_ view: UIView) -> Self {
        layout.parentView = view
        return self
    }
    
    /// Stretch horizontally and vertically
    public func matchParent() -> Self {
        return horizontal(.stretch).vertical(.stretch)
    }
    
    /// Stretch horizontally and vertically, in parent
    public func matchParent(_ view: UIView) -> Self {
        return parent(view).matchParent()
    }
    
    /// Set insets
    public func insets(_ insets: UIEdgeInsets) -> Self {
        layout.insets = insets
        return self
    }
    
    /// Set translatesAutoresizingMaskIntoConstraints to true
    public func translatesAutoresizingMaskIntoConstraints() -> Self {
        layout.translatesAutoresizingMaskIntoConstraints = true
        return self
    }
    
    /// Hug content more
    public func hugMore() -> Self {
        return hugMore(1)
    }
    
    /// Hug content more
    public func hugMore(_ value: Float) -> Self {
        layout.hug = .more(value)
        return self
    }
    
    /// Hug content less
    public func hugLess() -> Self {
        return hugLess(1)
    }
    
    /// Hug content less
    public func hugLess(_ value: Float) -> Self {
        layout.hug = .less(value)
        return self
    }
    
    /// Hug
    public func hug(_ value: Float) -> Self {
        layout.hug = .value(value)
        return self
    }
    
    /// Resist more
    public func resistMore() -> Self {
        return resistMore(1)
    }
    
    /// Resist more
    public func resistMore(_ value: Float) -> Self {
        layout.resist = .more(value)
        return self
    }
    
    /// Resist less
    public func resistLess() -> Self {
        return resistLess(1)
    }
    
    /// Resist less
    public func resistLess(_ value: Float) -> Self {
        layout.resist = .less(value)
        return self
    }
    
    /// Set resist
    public func resist(_ value: Float) -> Self {
        layout.resist = .value(value)
        return self
    }
    
    /// Set priority of constraints in this layout
    public func priority(_ value: Float) -> Self {
        return priority(UILayoutPriority(value))
    }
    
    /// Set priority of constraints in this layout
    public func priority(_ priority: UILayoutPriority) -> Self {
        layout.priority = priority
        return self
    }
    
    private var pinLeftValue: Float?
    private var pinRightValue: Float?
    private var pinTopValue: Float?
    private var pinBotValue: Float?
    
    /// Pin left
    public func pinLeft() -> Self {
        return pinLeft(0)
    }
    
    /// Pin left
    public func pinLeft(_ value: Float) -> Self {
        pinLeftValue = value
        return self
    }
    
    /// Pin right
    public func pinRight() -> Self {
        return pinRight(0)
    }
    
    /// Pin right
    public func pinRight(_ value: Float) -> Self {
        pinRightValue = value
        return self
    }
    
    /// Pin top
    public func pinTop() -> Self {
        return pinTop(0)
    }
    
    /// Pin top
    public func pinTop(_ value: Float) -> Self {
        pinTopValue = value
        return self
    }
    
    /// Pin bottom
    public func pinBottom() -> Self {
        return pinBottom(0)
    }
    
    /// Pin bottom
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
    
    /// Justify items
    public func justifyItems(_ value: LayoutJustify) -> Self {
        layout.justifyItems = value
        return self
    }
    
    /// Install the layout
    @discardableResult
    public func install() -> Self {
        updatePins()
        layout.install()
        return self
    }
    
    /// Reinstall the layout
    @discardableResult
    public func reinstall() -> Self {
        install()
        return self
    }
    
    /// uninstall the layout
    @discardableResult
    public func uninstall() -> Self {
        layout.uninstall()
        return self
    }
}
