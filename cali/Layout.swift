//
//  Layout.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class Layout {
    let id : UUID = UUID()
    weak var view: UIView?
    private var children: [Layout] = []
    private var constraints: [NSLayoutConstraint] = []
    weak var parent : Layout?
    
    var direction = LayoutDirection.Vertical
    var alignItems = LayoutFit.Stretch
    var useTopMarginGuide = false
    var useBottomMarginGuide = false
    var width = LayoutSize.Default
    var height = LayoutSize.Default
    var fitHorizontal = LayoutFit.Default
    var fitVertical = LayoutFit.Default
    var aspect: Float?
    var insets = UIEdgeInsets.zero
    var translatesAutoresizingMaskIntoConstraints = false
    var stackChildren = false
    
    private(set) var installed = false
    
    init (view: UIView) {
        self.view = view
        
        LayoutRegistry.add(layout: self)
        LayoutRunner.instance.startIfNeeded()
    }
    
    func addChild(child: Layout) {
        child.parent = self
        children.append(child)
    }
    
    private func installWidth() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch width {
        case .Default:
            break
        case .Ratio(let value):
            install(constraint:
                view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: CGFloat(value)))
        case .Value(let value):
            install(constraint:
                view.widthAnchor.constraint(equalToConstant: CGFloat(value)))
        }
    }
    
    private func installHeight() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch height {
        case .Default:
            break;
        case .Ratio(let value):
            install(constraint:
                view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: CGFloat(value)))
        case .Value(let value):
            install(constraint:
                view.heightAnchor.constraint(equalToConstant: CGFloat(value)))
        }
    }
    
    private func installItem() {
        guard let view = self.view else { return }
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        installWidth()
        installHeight()
        intallFitHorizontal()
        intallFitVertical()
        installAspect()
    }
    
    private func installAspect() {
        guard let view = self.view else { return }
        guard let aspect = self.aspect else { return }
        
        install(constraint:
            view.widthAnchor.constraint(equalTo: view.heightAnchor, multiplier: CGFloat(aspect)))
    }
    
    private func intallFitHorizontal() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        
        switch fitHorizontal {
        case .Default:
            break
        case .Leading:
            install(constraint:
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left))
        case .Center:
            install(constraint:
                view.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0))
        case .Trailing:
            install(constraint:
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right))
        case .Stretch:
            install(constraint:
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left))
            install(constraint:
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right))
        }
    }
    
    private func intallFitVertical() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch fitVertical {
        case .Default:
            break
        case .Leading:
            install(constraint:
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top))
        case .Center:
            install(constraint:
                view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0))
        case .Trailing:
            install(constraint:
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom))
        case .Stretch:
            install(constraint:
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top))
            install(constraint:
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom))
        }
    }
    
    private func installStack() {
        guard let view = self.view else { return }
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        var index = 0
        for child in children {
            installStackAxis(child: child, index: index)
            index += 1
        }
        
        for child in children {
            installAlignItems(child: child)
        }
    }
    
    private func installStackAxis(child: Layout, index: Int) {
        guard let childView = child.view else { return }
        guard let view = self.view else { return }
        
        switch direction {
        case .Vertical:
            if index == 0 {
                let topAnchor = useTopMarginGuide ?
                    view.layoutMarginsGuide.topAnchor :
                    view.topAnchor;
                
                let margin = child.insets.top
                install(constraint:
                    childView.topAnchor.constraint(equalTo: topAnchor, constant: margin))
            } else {
                let prevChild = children[index - 1]
                if let prevView = prevChild.view {
                    let margin = max(prevChild.insets.bottom, child.insets.top)
                    install(constraint:
                        childView.topAnchor.constraint(equalTo: prevView.bottomAnchor, constant: margin))
                }
            }
            
            if index == children.count - 1 {
                let bottomAnchor = useBottomMarginGuide ?
                    view.layoutMarginsGuide.bottomAnchor :
                    view.bottomAnchor;
                let margin = child.insets.bottom
                install(constraint:
                    childView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -margin))
            }
        case .Horizontal:
            if index == 0 {
                let margin = child.insets.left
                install(constraint:
                    childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: margin))
            } else {
                let prevChild = children[index - 1]
                if let prevView = prevChild.view {
                    let margin = max(prevChild.insets.right, child.insets.left)
                    install(constraint:
                        childView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: margin))
                }
            }
            
            if index == children.count - 1 {
                let margin = child.insets.right
                install(constraint:
                    childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -margin))
            }
        }
    }
    
    private func installAlignItems(child: Layout) {
        guard let view = self.view else { return }
        guard let childView = child.view else { return }
        
        switch direction {
        case .Vertical:
            switch alignItems {
            case .Default, .Leading:
                install(constraint:
                    childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: child.insets.top))
            case .Trailing:
                install(constraint:
                    childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -child.insets.bottom))
            case .Center:
                install(constraint:
                    childView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0))
            case .Stretch:
                install(constraint:
                    childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: child.insets.top))
                install(constraint:
                    childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -child.insets.bottom))
            }
        case .Horizontal:
            switch alignItems {
            case .Default, .Leading:
                install(constraint:
                    childView.topAnchor.constraint(equalTo: view.topAnchor, constant: child.insets.left))
            case .Trailing:
                install(constraint:
                    childView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -child.insets.right))
            case .Center:
                install(constraint:
                    childView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0))
            case .Stretch:
                install(constraint:
                    childView.topAnchor.constraint(equalTo: view.topAnchor, constant: child.insets.left))
                install(constraint:
                    childView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -child.insets.right))
            }
        }
    }
    
    private func install(constraint: NSLayoutConstraint) {
        constraint.isActive = true
        constraints.append(constraint)
    }
    
    func installIfNeeded() {
        if !installed {
            install()
            installed = true
        }
    }
    
    func install() {
        uninstall();
        
        if stackChildren {
            installStack()
        }
        
        installItem()
        
        for child in children {
            child.install()
        }
        
        installed = true
    }
    
    func uninstall() {
        for constraint in constraints {
            constraint.isActive = false
        }
        installed = false
    }
}
