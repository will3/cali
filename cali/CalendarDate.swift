//
//  CalendarDate.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class CalendarDate {
    let date: Date
    let calendar: Calendar
    var day: Int {
        return calendar.component(.day, from: date)
    }
    var formattedDay: String {
        return "\(day)"
    }
    
    var formattedMonth: String {
        return DateFormatters.LLLFormatter.string(from: date)
    }
    
    init(date: Date, calendar: Calendar) {
        self.date = date
        self.calendar = calendar
    }
}
