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
    
    private var didLoad = false
    
    private let timeLabel = UILabel()
    private let durationLabel = UILabel()
    private let titleLabel = UILabel()
    private let left = UIView()
    private let right = UIView()

    var event: Event? {
        didSet {
            updateEvent()
        }
    }

    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            if !didLoad {
                loadView()
                didLoad = true
            }
        }
    }
    
    private func loadView() {
        layout(contentView).stackHorizontal([
            layout(left).stack([
                layout(timeLabel).left(18).top(14),
                layout(durationLabel).left(18).top(2).bottom(18)
                ]),
            layout(right)
                .stack([
                    layout(titleLabel).left(18).right(18).top(14)
                    ])
                .justifyItems(.leading)
            ]).install()
        
        timeLabel.font = Fonts.fontSmall
        durationLabel.font = Fonts.fontSmall
        titleLabel.font = Fonts.fontMedium
        
        timeLabel.textColor = Colors.black
        durationLabel.textColor = Colors.primary
        titleLabel.textColor = Colors.black
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
