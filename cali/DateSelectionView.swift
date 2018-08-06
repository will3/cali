//
//  DateSelectionView.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class DateSelectionView : UIView {
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
    
    weak var delegate: CalendarViewDelegate? { didSet {
        calendarView.delegate = delegate
        } }
    
    let bar = UIView()
    let button = UIButton()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    var event : Event? { didSet {
        updateLabels()
        calendarView.selectedDate = event?.startDay } }
    
    let calendarView = CalendarView()
    let weekdayBar = WeekdayBar()
    var totalWidth = UIScreen.main.bounds.width { didSet {
        calendarView.totalWidth = totalWidth
        } }
    
    func loadView() {
        backgroundColor = UIColor.white
        
        dateLabel.textColor = Colors.accent
        dateLabel.font = Fonts.dayFont
        dateLabel.text = " "
        dateLabel.textAlignment = .center
        timeLabel.textColor = Colors.primary
        timeLabel.font = Fonts.calendarSmallLight
        timeLabel.text = " "
        timeLabel.textAlignment = .center
        
        let titleView = UIView()
        
        layout(titleView).stack([
            dateLabel,
            timeLabel
            ])
            .center(bar).install()
        
        layout(button)
            .parent(bar)
            .width(44)
            .height(44)
            .horizontal(.trailing)
            .vertical(.center)
            .install()
        
        // 6 rows
        let calendarViewHeight = Float(CalendarView.itemSizeForWidth(totalWidth).height) * 6.0
        
        layout(self).stack([
            layout(bar).height(60),
            weekdayBar,
            layout(calendarView)
                .height(calendarViewHeight)
                .hugLess()
        ]).install()
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
        
        updateLabels()
    }
    
    private func updateLabels() {
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        
        dateLabel.text = DateFormatters.EECommaDMMMFormatter.string(from: start)
        timeLabel.text = DateFormatters.formatMeetingDuration(start: start, end: end)
    }
}
