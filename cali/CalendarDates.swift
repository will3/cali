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
    let todayMonth: Int
    let indexForToday: Int
    
    init() {
        calendar = Calendar.current
        today = calendar.startOfDay(for: Date())
        
        let weekday = 1 // Sunday
        let sundayComponents = DateComponents(calendar: calendar, weekday: weekday)
        
        let thisSunday = calendar.nextDate(after: today, matching: sundayComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)!
        
        let settings = Settings.instance;
        
        startDate = calendar.date(byAdding: .day,
                                  value: -settings.numWeeksBackwards * 7,
                                  to: thisSunday)!
        numDates = (settings.numWeeksBackwards + settings.numWeeksForward) * 7
        
        todayMonth = calendar.dateComponents([ .month ], from: today).month!
        
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
    
    func isEvenNumberOfMonth(date: Date) -> Bool {
        if let numMonths = calendar.dateComponents([ .year, .month ], from: date).month {
            return numMonths % 2 == todayMonth % 2
        }
        return false
    }
    
    func isToday(date: Date) -> Bool {
        return date == today
    }
}
