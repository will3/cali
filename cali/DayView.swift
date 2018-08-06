//
//  DayView.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class EventHandleView: UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var loaded = false
    override func didMoveToSuperview() {
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    let circle = UIView()
    func loadView() {
        circle.backgroundColor = Colors.white
        let size = Float(20)
        circle.layer.cornerRadius = CGFloat(size) / 2
        circle.clipsToBounds = true
        circle.layer.borderWidth = 1
        circle.layer.borderColor = Colors.accent.cgColor
        
        layout(circle)
            .width(size)
            .height(size)
            .center(self).install()
    }
}

class DraggableEventView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var didLoad = false
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if !didLoad {
            loadView()
            didLoad = true
        }
    }
    
    let mainHandle = UIView()
    let topHandle = EventHandleView()
    let bottomHandle = EventHandleView()
    let handleSize = 44
    
    func loadView() {
        let halfHandleSize = CGFloat(handleSize / 2)
        mainHandle.backgroundColor = Colors.accent
        layout(mainHandle).matchParent(self).insets(UIEdgeInsetsMake(halfHandleSize, 0, halfHandleSize, 0)).install()
        layout(topHandle).parent(self).pinTop().pinRight().install()
        layout(bottomHandle).parent(self).pinBottom().pinLeft().install()
        
        mainHandle.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.mainDragged(tap:)))
        )
        
        topHandle.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.topDragged(tap:)))
        )
        
        bottomHandle.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.botDragged(tap:)))
        )
    }
    
    @objc func mainDragged(tap: UITapGestureRecognizer) {
        
    }
    
    @objc func topDragged(tap: UITapGestureRecognizer) {
        
    }
    
    @objc func botDragged(tap: UITapGestureRecognizer) {
        
    }
}

class DayView : UIView {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var loaded = false
    
    override func didMoveToSuperview() {
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    let scrollView = UIScrollView()
    let contentView = UIView()
    var labels : [UILabel] = []
    var startDay: Date? { didSet { updateLabels() } }
    let hours = 24
    
    private func updateLabels() {
        if labels.count == 0 {
            return
        }
        for i in 0...hours {
            let label = labels[i]
            if let time = startDay?.addingTimeInterval(TimeIntervals.hour * Double(i)) {
                label.text = DateFormatters.haFormatter.string(from: time)
            }
        }
    }
    
    func loadView() {
        layout(scrollView).matchParent(self).install()
        layout(contentView).matchParent(scrollView).install()
        
        
        let labelHalfHeight : Float = 6
        let hourHeight : Float = 60
        let botPadding : Float = 6
        let totalHeight = Float(hours) * hourHeight + labelHalfHeight * 2 + botPadding
        let labelWidth : Float = 50
        let graphStartX : Float = 54
        let graphRightPadding : Float = 2
        
        layout(contentView).width(.ratio(1)).height(totalHeight).install()
        
        for i in 0...hours {
            let label = UILabel()
            label.textColor = Colors.primary
            label.font = Fonts.graphSmall
            label.textAlignment = .right
            labels.append(label)
            
            layout(label)
                .parent(contentView)
                .pinLeft(0)
                .pinTop(Float(i) * hourHeight)
                .width(labelWidth)
                .install()
            
            let solidLine = UIView()
            solidLine.backgroundColor = Colors.separator
            layout(solidLine)
                .parent(contentView)
                .horizontal(.stretch)
                .left(graphStartX)
                .right(graphRightPadding)
                .pinTop(Float(i) * hourHeight + labelHalfHeight)
                .height(1)
                .install()
        }
        
        backgroundColor = Colors.white
        
        updateLabels()
    }
}
