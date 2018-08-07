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
    func draggableEventViewDidEndDrag(_ view: DraggableEventView)
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
    var event : Event? { didSet { updateEvent() } }
    var draggedStart: Date?
    var draggedDuration: TimeInterval?
    var dirty = false
    let timeLabel = UILabel()
    let durationLabel = UILabel()
    
    var paddingVertical: Float {
        return handleSize / 2
    }
    
    private func updateEvent() {
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        timeLabel.text = DateFormatters.formatMeetingDuration(start: start, end: end)
        durationLabel.text = DurationFormatter.formatMeetingDuration(from: start, to: end)
    }
    
    func loadView() {
        let halfHandleSize = CGFloat(handleSize / 2)
        mainHandle.backgroundColor = Colors.accent
        mainHandle.layer.cornerRadius = 2
        mainHandle.clipsToBounds = true
        
        timeLabel.textColor = Colors.white
        durationLabel.textColor = Colors.white
        timeLabel.font = Fonts.graphMedium
        durationLabel.font = Fonts.graphSmall
        
        layout(mainHandle).stack([
            layout(timeLabel).left(2).top(2),
            layout(durationLabel).left(2)
            ]).install()
        
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
        
        if pan.state == .ended {
            delegate?.draggableEventViewDidEndDrag(self)
        }
    }
    
    @objc func topDragged(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        delegate?.draggableEventViewDidDragTop(self, translation: translation)
        if pan.state == .ended {
            delegate?.draggableEventViewDidEndDrag(self)
        }
    }
    
    @objc func botDragged(pan: UIPanGestureRecognizer) {
        let translation = pan.translation(in: pan.view?.superview)
        delegate?.draggableEventViewDidDragBot(self, translation: translation)
        if pan.state == .ended {
            delegate?.draggableEventViewDidEndDrag(self)
        }
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
        if map[event.id] == nil {
            let eventView = DraggableEventView()
            map[event.id] = eventView
            eventView.event = event
            eventView.delegate = self
            eventLayer.addSubview(eventView)
        }
        
        placeEventView(map[event.id]!)
    }
    
    private func placeEventView(_ view: DraggableEventView) {
        guard let event = view.event else { return }
        guard let start = view.draggedStart ?? event.start else { return }
        guard let startDay = self.startDay else { return }
        guard let duration = view.draggedDuration ?? event.duration else { return }
        
        let timeInterval = start.timeIntervalSince(startDay)
        let x = graphStartX
        let y = labelHalfHeight + Float(timeInterval / TimeIntervals.hour * Double(hourHeight)) - view.paddingVertical
        let height = Float(duration / TimeIntervals.hour * Double(hourHeight)) + view.paddingVertical * 2
       
        if layouts[event.id] == nil {
           layouts[event.id] = layout(view)
        }
    
        layouts[event.id]?
            .pinLeft(x)
            .pinRight(graphRightPadding)
            .pinTop(y)
            .height(height)
            .install()
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
        var event = view.event
        if let draggedStart = view.draggedStart {
            event?.start = draggedStart
        }
        if let draggedDuration = view.draggedDuration {
            event?.duration = draggedDuration
        }
        view.event = event
        placeEventView(view)
    }
}
