//
//  CalendarDates.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class CalendarDates {
    let calendar: Calendar
    let startDate: Date
    let numDates: Int
    var numWeekRows: Int {
        return Int(ceil(Double(numDates) / 7.0))
    }
    
    let today: Date
    let startOfMonth: Date
    let indexForToday: Int
    
    init(today: Date, calendar: Calendar) {
        self.today = today
        self.calendar = calendar
        let weekday = 1 // Sunday
        let sundayComponents = DateComponents(calendar: calendar, weekday: weekday)
        
        let thisSunday = calendar.nextDate(after: today, matching: sundayComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)!
        
        let settings = Settings.instance;
        
        startDate = calendar.date(byAdding: .day,
                                  value: -settings.numWeeksBackwards * 7,
                                  to: thisSunday)!
        numDates = (settings.numWeeksBackwards + settings.numWeeksForward) * 7
        
        let startOfMonthComponents = calendar.dateComponents([ .year, .month ], from: today)
        startOfMonth = calendar.date(from: startOfMonthComponents)!
        
        let components = calendar.dateComponents([.day], from: startDate, to: today)
        indexForToday = components.day!
    }
    
    func getDate(weeks: Int) -> Date? {
        var components = DateComponents()
        components.day = weeks * 7
        return calendar.date(byAdding: components, to: startDate)
    }
    
    func getWeekIndex(date: Date) -> Int {
        let index = getIndex(date: date)
        return Int(floor(Double(index) / 7.0))
    }
    
    func getDate(index: Int) -> CalendarDate? {
        guard let date = calendar.date(byAdding: .day, value: index, to: startDate) else { return nil }
        
        return CalendarDate(date: date, calendar: calendar)
    }
    
    func getIndex(date: Date) -> Int {
        guard let day = calendar.dateComponents([.day], from: startDate, to: date).day else {
            return 0
        }
        return min(numDates - 1, max(0, day))
    }
    
    func isPastMonth(date: Date) -> Bool {
        return date.compare(startOfMonth) == .orderedAscending
    }
}
