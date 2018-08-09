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

class DraggableEventView : UIView, UIGestureRecognizerDelegate {
    weak var delegate : DraggableEventViewDelegate?
    let mainTapGesture = UITapGestureRecognizer()
    var opacityOnTap : Bool {
        return !isDraggable
    }
    
    var isDraggable = false {
        didSet {
            updateDraggable()
        }
    }
    
    private func updateDraggable() {
        if isDraggable {
            mainHandle.backgroundColor = Colors.accent.withAlphaComponent(Colors.draggableAlpha)
            timeLabel.textColor = Colors.white
            durationLabel.textColor = Colors.white
            titleLabel.textColor = Colors.white
            topHandle.isHidden = false
            bottomHandle.isHidden = false
            
            titleLabel.isHidden = true
            timeLabel.isHidden = false
            durationLabel.isHidden = false
        } else {
            mainHandle.backgroundColor =
                Colors.dimBackground.withAlphaComponent(Colors.draggableAlpha)
            timeLabel.textColor = Colors.primary
            durationLabel.textColor = Colors.primary
            titleLabel.textColor = Colors.primary
            topHandle.isHidden = true
            bottomHandle.isHidden = true
            
            titleLabel.isHidden = false
            timeLabel.isHidden = true
            durationLabel.isHidden = true
        }
    }
    
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
    let titleLabel = UILabel()
    
    var paddingVertical: Float {
        return handleSize / 2
    }
    
    private func updateEvent() {
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        timeLabel.text = EventFormatter.formatTimes(start: start, end: end)
        durationLabel.text = EventFormatter.formatDuration(from: start, to: end, durationTag: false)
        titleLabel.text = event.displayTitle
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
        
        titleLabel.font = Fonts.graphMedium
        
        layout(labelContainer).stack([
            layout(timeLabel).bottom(2),
            layout(durationLabel)
            ]).install()
        
        layout(labelContainer)
            .parent(mainHandle)
            .pinLeft(6)
            .pinTop(6)
            .install()
        
        layout(titleLabel)
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
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.mainDragged(pan:))))
        
        topHandle.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.topDragged(pan:))))
        
        bottomHandle.addGestureRecognizer(
            UIPanGestureRecognizer(target: self, action: #selector(DraggableEventView.botDragged(pan:))))
        
        mainHandle.addGestureRecognizer(mainTapGesture)
        mainTapGesture.delegate = self
        mainTapGesture.addTarget(self, action: #selector(DraggableEventView.mainTapped(tap:)))
        
        updateDraggable()
    }
    
    @objc func mainDragged(pan: UIPanGestureRecognizer) {
        if !isDraggable { return }
        let translation = pan.translation(in: pan.view?.superview)
        delegate?.draggableEventViewDidDrag(self, translation: translation)
        
        if pan.state == .ended {
            delegate?.draggableEventViewDidEndDrag(self)
        }
    }
    
    @objc func topDragged(pan: UIPanGestureRecognizer) {
        if !isDraggable { return }
        let translation = pan.translation(in: pan.view?.superview)
        delegate?.draggableEventViewDidDragTop(self, translation: translation)
        if pan.state == .ended {
            delegate?.draggableEventViewDidEndDrag(self)
        }
    }
    
    @objc func botDragged(pan: UIPanGestureRecognizer) {
        if !isDraggable { return }
        let translation = pan.translation(in: pan.view?.superview)
        delegate?.draggableEventViewDidDragBot(self, translation: translation)
        if pan.state == .ended {
            delegate?.draggableEventViewDidEndDrag(self)
        }
    }
    
    @objc func mainTapped(tap: UITapGestureRecognizer) {
        if !opacityOnTap {
            return
        }
        
        if tap.state == UIGestureRecognizerState.began {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 0.8
            }
        }
        
        if tap.state == UIGestureRecognizerState.ended {
            UIView.animate(withDuration: 0.2) {
                self.alpha = 1.0
            }
        }
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}
