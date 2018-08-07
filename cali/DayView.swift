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
        let size = Float(10)
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

protocol DraggableEventViewDelegate : AnyObject {
    func draggableEventViewDidDrag(_ view: DraggableEventView, translation: CGPoint)
    func draggableEventViewDidDragTop(_ view: DraggableEventView, translation: CGPoint)
    func draggableEventViewDidDragBot(_ view: DraggableEventView, translation: CGPoint)
}

class DraggableEventView : UIView {
    weak var delegate : DraggableEventViewDelegate?
    
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
    let handleSize = Float(20)
    var event : Event?
    
    var paddingVertical: Float {
        return handleSize / 2
    }
    
    func loadView() {
        layer.cornerRadius = 2
        clipsToBounds = true
        
        let halfHandleSize = CGFloat(handleSize / 2)
        mainHandle.backgroundColor = Colors.accent
        layout(mainHandle).matchParent(self).insets(UIEdgeInsetsMake(halfHandleSize, 0, halfHandleSize, 0)).install()
        layout(topHandle).parent(self).pinTop().pinRight(4)
            .width(handleSize).height(handleSize).install()
        layout(bottomHandle).parent(self).pinBottom().pinLeft(4)
            .width(handleSize).height(handleSize).install()
        
        mainHandle.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.mainDragged(pan:)))
        )
        
        topHandle.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.topDragged(pan:)))
        )
        
        bottomHandle.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.botDragged(pan:)))
        )
    }
    
    @objc func mainDragged(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        delegate?.draggableEventViewDidDrag(self, translation: translation)
    }
    
    @objc func topDragged(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        delegate?.draggableEventViewDidDragTop(self, translation: translation)
    }
    
    @objc func botDragged(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        delegate?.draggableEventViewDidDragBot(self, translation: translation)
    }
}

class DayView : UIView, DraggableEventViewDelegate {
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
    let eventLayer = UIView()
    var labels : [UILabel] = []
    var startDay: Date? { didSet {
        updateLabels()
        updateEvents() } }
    let hours = 24
    
    let labelHalfHeight : Float = 6
    let hourHeight : Float = 60
    let botPadding : Float = 6
    var totalHeight : Float {
        return Float(hours) * hourHeight + labelHalfHeight * 2 + botPadding
    }
    let labelWidth : Float = 50
    let graphStartX : Float = 54
    let graphRightPadding : Float = 2
    let eventService = EventService.instance
    
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
    
    private func updateEvents() {
        guard let startDay = self.startDay else { return }
        let events = eventService.find(startDay: startDay)
        for event in events {
            addEventView(event: event)
        }
    }
    
    var map: [ String: DraggableEventView ] = [:]
    
    private func addEventView(event: Event) {
        if map[event.id] == nil {
            let eventView = DraggableEventView()
            map[event.id] = eventView
            eventView.event = event
            eventView.delegate = self
            eventLayer.addSubview(eventView)
        }
        
        placeEventView(event: event, view: map[event.id]!)
    }
    
    private func placeEventView(event: Event, view: DraggableEventView) {
        guard let start = event.start else { return }
        guard let startDay = self.startDay else { return }
        guard let duration = event.duration else { return }
        
        let timeInterval = start.timeIntervalSince(startDay)
        let x = graphStartX
        let y = labelHalfHeight + Float(timeInterval / TimeIntervals.hour * Double(hourHeight)) - view.paddingVertical
        let height = Float(duration / TimeIntervals.hour * Double(hourHeight)) + view.paddingVertical * 2
        
        layout(view).pinLeft(x).pinRight(graphRightPadding).pinTop(y).height(height).install()
    }
    
    func loadView() {
        layout(scrollView).matchParent(self).install()
        layout(contentView).matchParent(scrollView).install()
        
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
        
        layout(eventLayer).matchParent(contentView).install()
        
        updateLabels()
    }
    
    // MARK: DraggableEventViewDelegate
    
    func draggableEventViewDidDrag(_ view: DraggableEventView, translation: CGPoint) {
        guard var event = view.event else { return }
        let timeInterval = Double(translation.y) / Double(hourHeight) * TimeIntervals.hour
        event.start?.addTimeInterval(timeInterval)
        
        eventService.update(event: event)
        updateEvents()
    }
    
    func draggableEventViewDidDragTop(_ view: DraggableEventView, translation: CGPoint) {
        
    }
    
    func draggableEventViewDidDragBot(_ view: DraggableEventView, translation: CGPoint) {
        
    }
}
