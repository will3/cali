//
//  DayView.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

protocol DayViewDelegate : AnyObject {
    func dayViewDidChangeEvent(_ event: Event)
}

class DayView : UIView, DraggableEventViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var loaded = false
    
    var delegate : DayViewDelegate?
    
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
        updateEvents() } }
    var event: Event? { didSet {
        updateEvents()
        }}
    let hours = 24
    
    let labelHalfHeight : Float = 6
    let hourHeight : Float = 60
    let botPadding : Float = 6
    var totalHeight : Float {
        return Float(hours) * hourHeight + labelHalfHeight * 2 + botPadding
    }
    let labelWidth : Float = 42
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
    
    var map: [ String: DraggableEventView ] = [:]
    var layouts: [ String: LayoutBuilder ] = [:]
    
    private func updateEvents() {
        guard let startDay = self.startDay else { return }
        let events = eventService.find(startDay: startDay)
        for event in events {
            addEventView(event: event)
        }
        
        if let event = self.event {
            addEventView(event: event)
        }
    }
    
    private func addEventView(event: Event) {
        guard let id = event.id  else { return }
        if map[id] == nil {
            let eventView = DraggableEventView()
            map[id] = eventView
            eventView.event = event
            eventView.delegate = self
            eventLayer.addSubview(eventView)
        }
        
        placeEventView(map[id]!)
    }
    
    private func placeEventView(_ view: DraggableEventView) {
        guard let event = view.event else { return }
        guard let id = event.id else { return }
        guard let start = view.draggedStart ?? event.start else { return }
        guard let startDay = self.startDay else { return }
        guard let duration = view.draggedDuration ?? event.duration else { return }
        
        let timeInterval = start.timeIntervalSince(startDay)
        let x = graphStartX
        let y = labelHalfHeight + Float(timeInterval / TimeIntervals.hour * Double(hourHeight)) - view.paddingVertical
        let height = Float(duration / TimeIntervals.hour * Double(hourHeight)) + view.paddingVertical * 2
       
        if layouts[id] == nil {
           layouts[id] = layout(view)
        }
    
        layouts[id]!
            .pinLeft(x)
            .pinRight(graphRightPadding)
            .pinTop(y)
            .height(height)
            .install()
    }
    
    func loadView() {
        scrollView.showsVerticalScrollIndicator = false
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
        guard let event = view.event else { return }
        let timeInterval = Double(translation.y) / Double(hourHeight) * TimeIntervals.hour
        view.draggedStart = event.start?.addingTimeInterval(timeInterval)
        view.dirty = true
        placeEventView(view)
    }
    
    func draggableEventViewDidDragTop(_ view: DraggableEventView, translation: CGPoint) {
        guard let event = view.event else { return }
        guard let duration = event.duration else { return }
        let timeInterval = Double(translation.y) / Double(hourHeight) * TimeIntervals.hour
        view.draggedStart = event.start?.addingTimeInterval(timeInterval)
        view.draggedDuration = duration - timeInterval
        placeEventView(view)
    }
    
    func draggableEventViewDidDragBot(_ view: DraggableEventView, translation: CGPoint) {
        guard let event = view.event else { return }
        guard let duration = event.duration else { return }
        let timeInterval = Double(translation.y) / Double(hourHeight) * TimeIntervals.hour
        view.draggedDuration = duration + timeInterval
        placeEventView(view)
    }
    
    func draggableEventViewDidEndDrag(_ view: DraggableEventView) {
        guard let event = view.event else { return }
        
        if let draggedStart = view.draggedStart {
            event.start = draggedStart
        }
        if let draggedDuration = view.draggedDuration {
            event.duration = draggedDuration
        }
        view.event = event
        placeEventView(view)
        
        delegate?.dayViewDidChangeEvent(event)
    }
}
