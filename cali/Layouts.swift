//
//  Layouts.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class Layouts {
    static func list(_ view: UIView) -> LayoutBuilder {
        return LayoutBuilder(view: view, type: LayoutType.List)
    }
    
    static func item(_ view: UIView) -> LayoutBuilder {
        return LayoutBuilder(view: view, type: LayoutType.Item)
    }
}

enum LayoutDirection {
    case Vertical
    case Horizontal
}

enum LayoutType {
    case Item
    case List
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
    
    @discardableResult
    func addChild(_ builder: LayoutBuilder) -> Self {
        layout.addChild(child: builder.layout)
        return self
    }
    
    @discardableResult
    func addChildren(_ builders: [LayoutBuilder]) -> Self {
        for builder in builders {
            addChild(builder)
        }
        return self
    }
    
    @discardableResult
    func width(_ width: LayoutSize) -> Self {
        layout.width = width
        return self
    }
    
    @discardableResult
    func height(_ height: LayoutSize) -> Self {
        layout.height = height
        return self
    }
    
    @discardableResult
    func width(_ width: Float) -> Self {
        layout.width = LayoutSize.Value(width)
        return self
    }
    
    @discardableResult
    func height(_ height: Float) -> Self {
        layout.height = LayoutSize.Value(height)
        return self
    }
    
    @discardableResult
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
    
    func install() {
        layout.install()
    }
}

class Layout {
    let view: UIView
    let type: LayoutType
    private var children: [Layout] = []
    
    var width = LayoutSize.Default
    var height = LayoutSize.Default
    var direction = LayoutDirection.Vertical
    var useTopMarginGuide = false
    var useBottomMarginGuide = false
    
    init (view: UIView, type: LayoutType) {
        self.view = view
        self.type = type
    }
    
    func addChild(child: Layout) {
        children.append(child)
    }
    
    func install() {
        switch type {
        case .List:
            installList()
            for child in children {
                child.installListItem()
            }
        case .Item:
            break
        }
    }
    
    private func installListItem() {
        view.translatesAutoresizingMaskIntoConstraints = false
        guard let superview = view.superview else {
            return
        }
        switch width {
        case .Default:
            install(constraint:
                view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0))
        case .MatchParent:
            install(constraint:
                view.widthAnchor.constraint(equalTo: superview.widthAnchor, multiplier: 1.0))
        case .Value(let value):
            install(constraint:
                view.widthAnchor.constraint(equalToConstant: CGFloat(value)))
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
        
        switch direction {
        case .Vertical:
            install(constraint:
                view.leftAnchor.constraint(equalTo: superview.leftAnchor, constant: 0))
            install(constraint:
                view.rightAnchor.constraint(equalTo: superview.rightAnchor, constant: 0))
        case .Horizontal:
            install(constraint:
                view.topAnchor.constraint(equalTo: superview.topAnchor, constant: 0))
            install(constraint:
                view.bottomAnchor.constraint(equalTo: superview.bottomAnchor, constant: 0))
        }
    }
    
    private func installList() {
        view.translatesAutoresizingMaskIntoConstraints = false
        var index = 0
        for child in children {
            
            switch direction {
            case .Vertical:
                if index == 0 {
                    let topAnchor = useTopMarginGuide ?
                        view.layoutMarginsGuide.topAnchor :
                        view.topAnchor;
                    
                    install(constraint:
                        child.view.topAnchor.constraint(equalTo: topAnchor, constant: 0))
                } else {
                    install(constraint:
                        child.view.topAnchor.constraint(equalTo: children[index - 1].view.bottomAnchor, constant: 0))
                }
                
                if index == children.count - 1 {
                    let bottomAnchor = useBottomMarginGuide ?
                        view.layoutMarginsGuide.bottomAnchor :
                        view.bottomAnchor;
                    
                    install(constraint:
                        child.view.bottomAnchor.constraint(equalTo: bottomAnchor, constant: 0))
                }
            case .Horizontal:
                if index == 0 {
                    install(constraint:
                        child.view.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0))
                } else {
                    install(constraint:
                        child.view.leadingAnchor.constraint(equalTo: children[index - 1].view.leadingAnchor, constant: 0))
                }
                
                if index == children.count - 1 {
                    install(constraint:
                        child.view.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0))
                }
            }
            
            
            index += 1
        }
    }
    
    private func install(constraint: NSLayoutConstraint) {
        constraint.isActive = true
        // TODO add to list
    }
}
