//
//  EventCell.swift
//  cali
//
//  Created by will3 on 8/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventCell : UITableViewCell {
    static let identifier = "EventCell"
    
    var didLoad = false
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            if !didLoad {
                loadView()
                didLoad = true
            }
        }
    }
    
    let timeLabel = UILabel()
    let durationLabel = UILabel()
    let titleLabel = UILabel()
    let left = UIView()
    let right = UIView()
    
    private func loadView() {
        layout(contentView).stackHorizontal([left, right]).install()
        layout(left).stack([timeLabel, durationLabel]).install()
        layout(right).stack([titleLabel]).install()
        layout(timeLabel).left(18).top(14).install()
        layout(durationLabel).left(18).top(2).bottom(18).install()
        layout(timeLabel).right(18).top(14).install()
        
        timeLabel.font = Fonts.fontSmall
        durationLabel.font = Fonts.fontSmall
        titleLabel.font = Fonts.fontMedium
        
        timeLabel.textColor = Colors.black
        durationLabel.textColor = Colors.primary
        titleLabel.textColor = Colors.black
    }
    
    var event: Event? {
        didSet {
            updateEvent()
        }
    }
    
    func updateEvent() {
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        timeLabel.text = DateFormatters.hmmaFormatter.string(from: start)
        durationLabel.text = EventFormatter.formatDuration(from: start, to: end, durationTag: false)
        titleLabel.text = event.displayTitle
    }
}
