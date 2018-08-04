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
        return Layouts.item(view)
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
    
    static func item(_ view: UIView) -> LayoutBuilder {
        return LayoutBuilder(view: view, type: LayoutType.Item)
    }
}

enum LayoutDirection {
    case Vertical
    case Horizontal
}

enum LayoutAlign {
    case Default
    case Left
    case Center
    case Right
}

enum LayoutAlignVertical {
    case Default
    case Top
    case Center
    case Bottom
}

enum LayoutType {
    case Item
    case Stack
}

enum LayoutSize {
    case Default
    case MatchParent
    case Value(Float)
}

class LayoutBuilder {
    let layout: Layout
    
    init (view: UIView, type: LayoutType) {
        layout = Layout(view: view, type: type)
    }
    
    func addChild(_ wrapper: LayoutBuilder) -> Self {
        layout.addChild(child: wrapper.layout)
        return self
    }
    
    func addChildren(_ wrappers: [LayoutBuilder]) -> Self {
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
    
    func align(_ align: LayoutAlign) -> Self {
        layout.align = align
        return self
    }
    
    func alignVertical(_ alignVertical: LayoutAlignVertical) -> Self {
        layout.alignVertical = alignVertical
        return self
    }
    
    func center() -> Self {
        return align(LayoutAlign.Center).alignVertical(LayoutAlignVertical.Center)
    }
    
    func matchParent() -> Self {
        return align(LayoutAlign.Left)
            .alignVertical(LayoutAlignVertical.Center)
            .width(LayoutSize.MatchParent)
            .height(LayoutSize.MatchParent)
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

class Layout {
    let id : UUID = UUID()
    weak var view: UIView?
    let type: LayoutType
    private var children: [Layout] = []
    private var constraints: [NSLayoutConstraint] = []
    
    var direction = LayoutDirection.Vertical
    var alignItems = LayoutAlign.Left
    var useTopMarginGuide = false
    var useBottomMarginGuide = false
    
    var width = LayoutSize.Default
    var height = LayoutSize.Default
    
    var align = LayoutAlign.Default
    var alignVertical = LayoutAlignVertical.Default
    weak var parent : Layout?
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
            if parent?.type == LayoutType.Stack {
                install(constraint:
                    view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0))
            }
        case .MatchParent:
            install(constraint:
                view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0))
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
        case .MatchParent:
            install(constraint:
                view.heightAnchor.constraint(equalTo: superview.heightAnchor, multiplier: 1.0))
        case .Value(let value):
            install(constraint:
                view.heightAnchor.constraint(equalToConstant: CGFloat(value)))
        }
    }
    
    private func installItem() {
        guard let view = self.view else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
        installWidth()
        installHeight()
        installAlign()
        installAlignVertical()
    }
    
    private func installAlign() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch align {
        case .Default:
            break
        case .Left:
            install(constraint:
                view.leadingAnchor.constraint(equalTo: superview.leadingAnchor, constant: 0))
        case .Center:
            install(constraint:
                view.centerXAnchor.constraint(equalTo: superview.centerXAnchor, constant: 0))
        case .Right:
            install(constraint:
                view.trailingAnchor.constraint(equalTo: superview.trailingAnchor, constant: 0))
        }
    }
    
    private func installAlignVertical() {
        guard let view = self.view else { return }
        guard let superview = view.superview else {
            return
        }
        switch alignVertical {
        case .Default:
            break
        case .Top:
            install(constraint:
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0))
        case .Center:
            install(constraint:
                view.centerYAnchor.constraint(equalTo: superview.centerYAnchor, constant: 0))
        case .Bottom:
            install(constraint:
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0))
        }
    }
    
    private func installStack() {
        guard let view = self.view else { return }
        view.translatesAutoresizingMaskIntoConstraints = false
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
                            childView.leadingAnchor.constraint(equalTo: prevView.leadingAnchor, constant: 0))
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
            switch alignItems {
            case .Default, .Left:
                install(constraint:
                    childView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0))
            case .Right:
                install(constraint:
                    childView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0))
            case .Center:
                install(constraint:
                    childView.centerXAnchor.constraint(equalTo: view.centerXAnchor, constant: 0))
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
