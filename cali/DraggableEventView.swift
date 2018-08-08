//
//  DraggableEventView.swift
//  cali
//
//  Created by will3 on 7/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

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
    let handleSize = Float(44)
    var event : Event? { didSet { updateEvent() } }
    var draggedStart: Date?
    var draggedDuration: TimeInterval?
    var dirty = false
    let timeLabel = UILabel()
    let durationLabel = UILabel()
    let labelContainer = UIView()
    
    var paddingVertical: Float {
        return handleSize / 2
    }
    
    private func updateEvent() {
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        timeLabel.text = EventFormatter.formatTimes(start: start, end: end)
        durationLabel.text = EventFormatter.formatDuration(from: start, to: end, durationTag: false)
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
        
        layout(labelContainer).stack([
            layout(timeLabel).bottom(2),
            layout(durationLabel)
            ]).install()
        
        layout(labelContainer)
            .parent(mainHandle)
            .pinLeft(6)
            .pinTop(6)
            .install()
        
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
