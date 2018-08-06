//
//  EventDateTimeCell.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class EventDateTimeCell : UITableViewCell {
    static let identifier = "EventDateTimeCell"
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    private let dateTitleLabel = UILabel()
    private let dateValueLabel = UILabel()
    private let dateDiffLabel = UILabel()
    
    private let timeTitleLabel = UILabel()
    private let timeValueLabel = UILabel()
    private let timeDurationLabel = UILabel()
    
    private let left = UIView()
    private let right = UIView()
    
    var event: Event? { didSet { updateEvent() } }
    
    func loadView() {
        dateTitleLabel.text = " "
        dateTitleLabel.textColor = Colors.primary
        dateValueLabel.text = " "
        dateValueLabel.textColor = Colors.black
        dateDiffLabel.text = " "
        dateDiffLabel.textColor = Colors.primary
        
        timeTitleLabel.text = " "
        timeTitleLabel.textColor = Colors.primary
        timeValueLabel.text = " "
        timeValueLabel.textColor = Colors.primary
        timeDurationLabel.text = " "
        timeDurationLabel.textColor = Colors.primary
        
        let labelHeight: Float = 24.0
        let insets = UIEdgeInsetsMake(8, 12, 8, 12)
        
        let border = UIView()
        border.backgroundColor = Colors.separator
        
        layout(contentView)
            .translatesAutoresizingMaskIntoConstraints()
            .stackHorizontal([
                layout(left).stack([
                    layout(dateTitleLabel).height(.value(labelHeight)),
                    layout(dateValueLabel).height(.value(labelHeight)),
                    layout(dateDiffLabel).height(.value(labelHeight))
                    ]).insets(insets),
                layout(border).width(1),
                layout(right).stack([
                    layout(timeTitleLabel).height(.value(labelHeight)).hugMore(),
                    layout(timeValueLabel).height(.value(labelHeight)).hugMore(),
                    layout(timeDurationLabel).height(.value(labelHeight)).hugMore()
                    ]).insets(insets)
                ])
            .install()
        updateEvent()
        
        let leftButton = UIButton()
        left.addSubview(leftButton)
        leftButton.addTarget(self, action: #selector(EventDateTimeCell.didPressLeft), for: .touchUpInside)
        layout(leftButton).matchParent().install()
        
        let rightButton = UIButton()
        rightButton.addTarget(self, action: #selector(EventDateTimeCell.didPressRight), for: .touchUpInside)
        right.addSubview(rightButton)
        layout(rightButton).matchParent().install()
        
        selectionStyle = .none
    }
    
    @objc func didPressLeft() {
        
    }
    
    @objc func didPressRight() {
        
    }
    
    func updateEvent() {
        dateTitleLabel.text = NSLocalizedString("Date", comment: "")
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        
        dateValueLabel.text = DateFormatters
            .EEEddMMMFormatter.string(from: start)
        dateDiffLabel.text = DurationFormatter.formatRelative(from: start, to: end)
        timeTitleLabel.text = NSLocalizedString("Time", comment: "")
        let startTimeText = DateFormatters.hmmaFormatter.string(from: start)
        let endTimeText = DateFormatters.hmmaFormatter.string(from: end)
        
        let boldStartTimeText = DateFormatters.hmmFormatter.string(from: start)
        let boldEndTimeText = DateFormatters.hmmFormatter.string(from: end)
        
        let text = String(format:NSLocalizedString("%1$@ → %2$@", comment: "Create event start time to end time"), startTimeText, endTimeText)
        
        let attributedText = NSMutableAttributedString(string: text)
        
        let boldStartTimeRange = (text as NSString).range(of: boldStartTimeText)
        
        if boldStartTimeRange.location != NSNotFound {
            attributedText.setAttributes([
                NSAttributedStringKey.foregroundColor: Colors.black ], range: boldStartTimeRange)
        }
        
        let boldEndTimeRange = (text as NSString).range(of: boldEndTimeText)
        
        if boldEndTimeRange.location != NSNotFound {
            attributedText.setAttributes([
                NSAttributedStringKey.foregroundColor: Colors.black ], range: boldEndTimeRange)
        }
        
        timeValueLabel.attributedText = attributedText
        timeDurationLabel.text = DurationFormatter.formatMeetingDuration(from: start, to: end)
    }
}