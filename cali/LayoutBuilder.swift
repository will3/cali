//
//  LayoutBuilder.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class LayoutBuilder {
    let layout: Layout
    
    init (view: UIView) {
        layout = Layout(view: view)
    }
    
    func stack(_ wrappers: [LayoutBuilder]) -> Self {
        layout.stackChildren = true
        for wrapper in wrappers {
            layout.addChild(child: wrapper.layout)
        }
        return self
    }
    
    func width(_ width: LayoutSize) -> Self {
        layout.width = width
        return self
    }
    
    func height(_ height: LayoutSize) -> Self {
        layout.height = height
        return self
    }
    
    func width(_ width: Float) -> Self {
        layout.width = LayoutSize.Value(width)
        return self
    }
    
    func height(_ height: Float) -> Self {
        layout.height = LayoutSize.Value(height)
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
        return horizontal(LayoutFit.Center).vertical(LayoutFit.Center)
    }
    
    func matchParent() -> Self {
        return horizontal(LayoutFit.Stretch).vertical(LayoutFit.Stretch)
    }
    
    func insets(_ insets: UIEdgeInsets) -> Self {
        layout.insets = insets
        return self
    }
    
    func translatesAutoresizingMaskIntoConstraints() -> Self {
        layout.translatesAutoresizingMaskIntoConstraints = true
        return self
    }
    
    func install() {
        layout.install()
    }
    
    func reinstall() {
        layout.install()
    }
    
    func uninstall() {
        layout.uninstall()
    }
}
