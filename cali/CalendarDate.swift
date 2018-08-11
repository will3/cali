//
//  CalendarDate.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Wrapper for a calendar date
class CalendarDate {
    init(date: Date, calendar: Calendar) {
        self.date = date
        self.calendar = calendar
    }
    
    /// Date
    let date: Date
    
    /// Calendar
    let calendar: Calendar
    
    /// Day of month
    var day: Int {
        return calendar.component(.day, from: date)
    }
    
    /// UTC date
    var dateUTC: Date {
        return date.addingTimeInterval(Double(TimeZone.current.secondsFromGMT()))
    }
    
    /// Formatted day of month
    var formattedDay: String {
        return "\(day)"
    }
    
    /// Formatted month
    var formattedMonth: String {
        return DateFormatters.LLLFormatter.string(from: date)
    }
}
