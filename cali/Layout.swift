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
    
    var direction = LayoutDirection.vertical
    var alignItems = LayoutFit.stretch
    var useTopMarginGuide = false
    var useBottomMarginGuide = false
    var width = LayoutSize.none
    var height = LayoutSize.none
    var fitHorizontal = LayoutFit.none
    var fitVertical = LayoutFit.none
    var aspect: Float?
    var insets = UIEdgeInsets.zero
    var translatesAutoresizingMaskIntoConstraints = false
    var stackChildren = false
    var minWidth = LayoutSize.none
    var maxWidth = LayoutSize.none
    var minHeight = LayoutSize.none
    var maxHeight = LayoutSize.none
    var hug = LayoutPriority.none
    var resist = LayoutPriority.none
    var originalHugHorizontal: UILayoutPriority?
    var originalHugVertical: UILayoutPriority?
    var originalResistHorizontal: UILayoutPriority?
    var originalResistVertical: UILayoutPriority?
    
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
        case .none:
            break
        case .ratio(let value):
            install(constraint:
                view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: CGFloat(value)))
        case .value(let value):
            install(constraint:
                view.widthAnchor.constraint(equalToConstant: CGFloat(value)))
        }
    }
    
    private func installMinWidth() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch width {
        case .none:
            break
        case .ratio(let value):
            install(constraint:
                view.widthAnchor.constraint(greaterThanOrEqualTo: superview.widthAnchor, multiplier: CGFloat(value)))
        case .value(let value):
            install(constraint:
                view.widthAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(value)))
        }
    }
    
    private func installMaxWidth() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch width {
        case .none:
            break
        case .ratio(let value):
            install(constraint:
                view.widthAnchor.constraint(lessThanOrEqualTo: superview.widthAnchor, multiplier: CGFloat(value)))
        case .value(let value):
            install(constraint:
                view.widthAnchor.constraint(lessThanOrEqualToConstant: CGFloat(value)))
        }
    }
    
    private func installHeight() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch height {
        case .none:
            break;
        case .ratio(let value):
            install(constraint:
                view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: CGFloat(value)))
        case .value(let value):
            install(constraint:
                view.heightAnchor.constraint(equalToConstant: CGFloat(value)))
        }
    }
    
    private func installMinHeight() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch height {
        case .none:
            break
        case .ratio(let value):
            install(constraint:
                view.heightAnchor.constraint(greaterThanOrEqualTo: superview.heightAnchor, multiplier: CGFloat(value)))
        case .value(let value):
            install(constraint:
                view.heightAnchor.constraint(greaterThanOrEqualToConstant: CGFloat(value)))
        }
    }
    
    private func installMaxHeight() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch height {
        case .none:
            break
        case .ratio(let value):
            install(constraint:
                view.heightAnchor.constraint(lessThanOrEqualTo: superview.heightAnchor, multiplier: CGFloat(value)))
        case .value(let value):
            install(constraint:
                view.heightAnchor.constraint(lessThanOrEqualToConstant: CGFloat(value)))
        }
    }
    
    private func installItem() {
        guard let view = self.view else { return }
        view.translatesAutoresizingMaskIntoConstraints = translatesAutoresizingMaskIntoConstraints
        installWidth()
        installMinWidth()
        installMaxWidth()
        installHeight()
        installMinHeight()
        installMaxHeight()
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
        case .none:
            break
        case .leading:
            install(constraint:
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: insets.left))
        case .center:
            install(constraint:
                view.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0))
        case .trailing:
            install(constraint:
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: -insets.right))
        case .stretch:
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
        case .none:
            break
        case .leading:
            install(constraint:
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: insets.top))
        case .center:
            install(constraint:
                view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0))
        case .trailing:
            install(constraint:
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: -insets.bottom))
        case .stretch:
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
        
        for child in children {
            installChildHug(child: child)
            installChildResist(child: child)
        }
    }
    
    func installChildHug(child: Layout) {
        guard let childView = child.view else { return }
        initOriginalLayoutPriorities()
        
        let axis: UILayoutConstraintAxis = direction == .horizontal ? .horizontal : .vertical
        guard let originalValue: UILayoutPriority = direction == .horizontal ? originalHugHorizontal : originalHugVertical else { return }
        
        switch hug {
        case .none:
            break
        case .less(let value): childView.setContentHuggingPriority(UILayoutPriority(originalValue.rawValue - value), for: axis)
        case .more(let value): childView.setContentHuggingPriority(UILayoutPriority(originalValue.rawValue + value), for: axis)
        case .value(let value): childView.setContentHuggingPriority(UILayoutPriority(value), for: axis)
        }
    }
    
    func installChildResist(child: Layout) {
        guard let childView = child.view else { return }
        initOriginalLayoutPriorities()
        
        let axis: UILayoutConstraintAxis = direction == .horizontal ? .horizontal : .vertical
        guard let originalValue: UILayoutPriority = direction == .horizontal ? originalResistHorizontal : originalResistVertical else { return }
        
        switch hug {
        case .none:
            break
        case .less(let value): childView.setContentCompressionResistancePriority(UILayoutPriority(originalValue.rawValue - value), for: axis)
        case .more(let value): childView.setContentCompressionResistancePriority(UILayoutPriority(originalValue.rawValue + value), for: axis)
        case .value(let value): childView.setContentCompressionResistancePriority(UILayoutPriority(value), for: axis)
        }
    }
    
    func initOriginalLayoutPriorities() {
        guard let view = self.view else { return }
        if originalHugHorizontal == nil {
            originalHugHorizontal = view.contentHuggingPriority(for: .horizontal)
        }
        
        if originalHugVertical == nil {
            originalHugVertical = view.contentHuggingPriority(for: .vertical)
        }
        
        if originalResistHorizontal == nil {
            originalResistHorizontal = view.contentCompressionResistancePriority(for: .horizontal)
        }
        
        if originalResistVertical == nil {
            originalResistVertical =
                view.contentCompressionResistancePriority(for: .vertical)
        }
    }
    
    private func installStackAxis(child: Layout, index: Int) {
        guard let childView = child.view else { return }
        guard let view = self.view else { return }
        
        switch direction {
        case .vertical:
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
        case .horizontal:
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
        case .vertical:
            switch alignItems {
            case .none, .leading:
                install(constraint:
                    childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: child.insets.top))
            case .trailing:
                install(constraint:
                    childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -child.insets.bottom))
            case .center:
                install(constraint:
                    childView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0))
            case .stretch:
                install(constraint:
                    childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: child.insets.top))
                install(constraint:
                    childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -child.insets.bottom))
            }
        case .horizontal:
            switch alignItems {
            case .none, .leading:
                install(constraint:
                    childView.topAnchor.constraint(equalTo: view.topAnchor, constant: child.insets.left))
            case .trailing:
                install(constraint:
                    childView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -child.insets.right))
            case .center:
                install(constraint:
                    childView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0))
            case .stretch:
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
            addSubviewsIfNeeded()
            installStack()
        }
        
        installItem()
        
        for child in children {
            child.install()
        }
        
        installed = true
    }
    
    func addSubviewsIfNeeded() {
        for child in children {
            guard let view = child.view else { continue }
            guard let parentView = self.view else { continue }
            
            if view.superview != parentView {
                parentView.addSubview(view)
            }
        }
    }
    
    func uninstall() {
        for constraint in constraints {
            constraint.isActive = false
        }
        installed = false
    }
}
