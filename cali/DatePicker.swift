//
//  DateSelectionView.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

protocol DatePickerDelegate : AnyObject {
    func datePickerDidFinish(_ datePicker: DatePicker)
    func datePickerDidChange(_ datePicker: DatePicker)
}

class DatePicker : UIView, CalendarViewDelegate {
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var loaded = false
    weak var delegate : DatePickerDelegate?
    
    override func didMoveToSuperview() {
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    let bar = UIView()
    let button = UIButton()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    
    var event : Event? { didSet {
        updateLabels()
        calendarView.selectedDate = event?.startDay } }
    
    var selectedDate: Date? {
        return calendarView.selectedDate
    }
    
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
        
        button.setImage(Images.tick, for: .normal)
        button.addTarget(self, action: #selector(DatePicker.didPressDone), for: .touchUpInside)
        layout(button)
            .parent(bar)
            .width(44)
            .height(44)
            .horizontal(.trailing)
            .vertical(.center)
            .install()
        
        // 6 rows
        let calendarViewHeight = Float(CalendarView.itemSizeForWidth(totalWidth).height) * 6.0
        calendarView.delegate = self
        
        layout(self).stack([
            layout(bar).height(50),
            weekdayBar,
            layout(calendarView)
                .height(calendarViewHeight)
                .hugLess()
        ]).install()
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
        
        updateLabels()
    }
    
    @objc func didPressDone() {
        delegate?.datePickerDidFinish(self)
    }
    
    private func updateLabels() {
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        
        dateLabel.text = DateFormatters.EECommaDMMMFormatter.string(from: start)
        timeLabel.text = EventFormatter.formatTimes(start: start, end: end)
    }

    // MARK: CalendarViewDelegate
    
    func calendarViewDidChangeSelectedDate(_ calendarView: CalendarView) {
        self.delegate?.datePickerDidChange(self)
    }
}
