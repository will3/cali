//
//  DateSelectionView.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

protocol DatePickerDelegate : AnyObject {
    func datePickerDidFinish(_ datePicker: DatePicker)
    func datePickerDidChange(_ datePicker: DatePicker)
}

/// Event date picker
class DatePicker : UIView, CalendarViewDelegate {
    /// View loaded
    private var loaded = false
    /// Delegate
    weak var delegate : DatePickerDelegate?
    
    override func didMoveToSuperview() {
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    /// Bar
    private let bar = UIView()
    /// Button
    private let button = UIButton()
    /// Date label
    private let dateLabel = UILabel()
    /// Time label
    private let timeLabel = UILabel()
    
    /// Event
    var event : Event? { didSet {
        updateLabels()
        calendarView.selectedDate = event?.startDay } }
    
    /// Selected date
    var selectedDate: Date? {
        return calendarView.selectedDate
    }
    
    /// Calendar view
    private let calendarView = CalendarView()
    /// Week day bar
    private let weekdayBar = WeekdayBar()
    /// Total width
    var totalWidth = UIScreen.main.bounds.width { 
        didSet { 
            calendarView.totalWidth = totalWidth 
        } 
    }
    
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
            layout(dateLabel),
            layout(timeLabel)
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
            layout(weekdayBar),
            layout(calendarView)
                .height(calendarViewHeight)
                .hugLess()
        ]).install()
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
        
        updateLabels()
    }
    
    @objc private func didPressDone() {
        delegate?.datePickerDidFinish(self)
    }

    // MARK: CalendarViewDelegate
    
    func calendarViewDidChangeSelectedDate(_ calendarView: CalendarView) {
        self.delegate?.datePickerDidChange(self)
    }

    // MARK: Private

    private func updateLabels() {
        guard let event = self.event else { return }
        guard let start = event.start else { return }
        guard let end = event.end else { return }
        
        dateLabel.text = DateFormatters.EECommaDMMMFormatter.string(from: start)
        timeLabel.text = EventFormatter.formatTimes(start: start, end: end)
    }
}
