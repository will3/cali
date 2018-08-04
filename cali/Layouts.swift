//
//  Layouts.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

#if !NO_LAYOUT_SHORTHANDS
    func layout(_ view: UIView) -> LayoutBuilder {
        return Layouts.view(view)
    }
    
    func layoutStack(_ view: UIView) -> LayoutBuilder {
        return Layouts.stack(view)
    }
#endif

class LayoutRegistry {
    static var layouts: [UUID : Layout] = [:]
    static func add(layout: Layout) {
        layouts[layout.id] = layout
    }
}

class LayoutRunner {
    static let instance = LayoutRunner()
    private var timer : Timer?;
    var started = false
    
    func startIfNeeded() {
        if started {
            return
        }
        start()
        started = true
    }
    
    func start() {
        timer = Timer.scheduledTimer(withTimeInterval: 1 / 60.0, repeats: true) { timer in
            self.checkViewReleased()
        }
        started = true
    }
    
    func checkViewReleased() {
        let keys = LayoutRegistry.layouts.keys
        for key in keys {
            if let layout = LayoutRegistry.layouts[key] {
                if (layout.view == nil) {
                    LayoutRegistry.layouts.removeValue(forKey: layout.id)
                }
            }
        }
    }
    
    func stop() {
        timer?.invalidate()
        started = false
    }
}

class Layouts {
    static func stack(_ view: UIView) -> LayoutBuilder {
        return LayoutBuilder(view: view, type: LayoutType.Stack)
    }
    
    static func view(_ view: UIView) -> LayoutBuilder {
        return LayoutBuilder(view: view, type: LayoutType.Item)
    }
}

enum LayoutDirection {
    case Vertical
    case Horizontal
}

enum LayoutType {
    case Item
    case Stack
}

enum LayoutSize {
    case Default
    case Value(Float)
    case Ratio(Float)
}

class LayoutBuilder {
    let layout: Layout
    
    init (view: UIView, type: LayoutType) {
        layout = Layout(view: view, type: type)
    }
    
    func children(_ wrappers: [LayoutBuilder]) -> Self {
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

enum LayoutFit {
    case Default
    case Leading
    case Center
    case Trailing
    case Stretch
}

class Layout {
    let id : UUID = UUID()
    weak var view: UIView?
    let type: LayoutType
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
    
    private(set) var installed = false
    
    init (view: UIView, type: LayoutType) {
        self.view = view
        self.type = type
        
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
            guard let childView = child.view else { continue }
            switch direction {
            case .Vertical:
                if index == 0 {
                    let topAnchor = useTopMarginGuide ?
                        view.layoutMarginsGuide.topAnchor :
                        view.topAnchor;
                    
                    install(constraint:
                        childView.topAnchor.constraint(equalTo: topAnchor, constant: 0))
                } else {
                    if let prevView = children[index - 1].view {
                        install(constraint:
                            childView.topAnchor.constraint(equalTo: prevView.bottomAnchor, constant: 0))
                    }
                }
                
                if index == children.count - 1 {
                    let bottomAnchor = useBottomMarginGuide ?
                        view.layoutMarginsGuide.bottomAnchor :
                        view.bottomAnchor;
                    
                    install(constraint:
                        childView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0))
                }
            case .Horizontal:
                if index == 0 {
                    install(constraint:
                        childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0))
                } else {
                    if let prevView = children[index - 1].view {
                        install(constraint:
                            childView.leadingAnchor.constraint(equalTo: prevView.trailingAnchor, constant: 0))
                    }
                }
                
                if index == children.count - 1 {
                    install(constraint:
                        childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0))
                }
            }
            
            index += 1
        }
        
        for child in children {
            guard let childView = child.view else { continue }
            switch direction{
            case .Vertical:
                switch alignItems {
                case .Default, .Leading:
                    install(constraint:
                        childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0))
                case .Trailing:
                    install(constraint:
                        childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0))
                case .Center:
                    install(constraint:
                        childView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0))
                case .Stretch:
                    install(constraint:
                        childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0))
                    install(constraint:
                        childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0))
                }
            case .Horizontal:
                switch alignItems {
                case .Default, .Leading:
                    install(constraint:
                        childView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0))
                case .Trailing:
                    install(constraint:
                        childView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0))
                case .Center:
                    install(constraint:
                        childView.centerYAnchor.constraint(equalTo: view.centerYAnchor, constant: 0))
                case .Stretch:
                    install(constraint:
                        childView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0))
                    install(constraint:
                        childView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0))
                }
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
        switch type {
        case .Stack:
            installStack()
        case .Item:
            installItem()
        }
        
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
