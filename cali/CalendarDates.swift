//
//  CalendarDates.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Represents a range of dates that the calendar displays
class CalendarDates {
    /// Calendar
    let calendar = Injection.defaultContainer.calendar
    /// Start date
    let startDate: Date
    /// Number of dates in total
    let numDates: Int
    /// Number of rows if each weak is a row
    var numWeekRows: Int {
        return Int(ceil(Double(numDates) / 7.0))
    }
    /// Today
    let today: Date
    /// Month of today
    let todayMonth: Int
    /// Index, from start date, of today
    let indexForToday: Int
    
    init() {
        let now = Injection.defaultContainer.nowProvider.now
        today = calendar.startOfDay(for: now)
        
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
    
    /**
     * Get first day of week, given number of weeks from start date
     * 
     * - parameter weeks: Number of weeks from start date
     * - returns: First day of week
     */
    func getDate(weeks: Int) -> Date? {
        var components = DateComponents()
        components.day = weeks * 7
        return calendar.date(byAdding: components, to: startDate)
    }

    /**
     * Get week index from start date, given date
     * 
     * - parameter date: Date
     * - returns: Number of weeks from start date
     */
    func getWeekIndex(date: Date) -> Int {
        let index = getIndex(date: date)
        return Int(floor(Double(index) / 7.0))
    }
    
    /**
     * Get date, given index from start date
     * 
     * - parameter index: Number of days from start date
     * - returns: Number of days from start date
     */
    func getDate(index: Int) -> CalendarDate? {
        guard let date = calendar.date(byAdding: .day, value: index, to: startDate) else { return nil }
        
        return CalendarDate(date: date, calendar: calendar)
    }
    
    /**
     * Get index from start date, given date
     * 
     * - parameter date: Date
     * - returns: Date
     */
    func getIndex(date: Date) -> Int {
        guard let day = calendar.dateComponents([.day], from: startDate, to: date).day else {
            return 0
        }
        return min(numDates - 1, max(0, day))
    }
    
    /**
     * Get if month is even number of month from today
     * 
     * - parameter date: Date
     * - returns: True is even number of month from today
     */
    func isEvenNumberOfMonth(date: Date) -> Bool {
        if let numMonths = calendar.dateComponents([ .year, .month ], from: date).month {
            return numMonths % 2 == todayMonth % 2
        }
        return false
    }

    /**
     * Return is date is today
     * 
     * - parameter date: Date
     * - returns: True if date is today
     */
    func isToday(date: Date) -> Bool {
        return date == today
    }
}
