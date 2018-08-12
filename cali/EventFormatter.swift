//
//  DurationFormatter.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class EventFormatter {
    static let calendar = Injection.defaultContainer.calendar
    
    /**
     * Format a date relative 
     *
     * - parameter from: From date
     * - parameter from: To date
     * - returns: Formatted string
     */
    static func formatRelative(from: Date, to: Date) -> String {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: from, to: to)
        
        if let year = components.year {
            if year == 1 {
                return NSLocalizedString("In 1 year", comment: "")
            } else if year > 0 {
                return String(format: NSLocalizedString("In %d years", comment: ""), year)
            } else if year == -1 {
                return String(format: NSLocalizedString("Last year", comment: ""), year)
            } else if year < 0 {
                return String(format: NSLocalizedString("%d years ago", comment: ""), -year)
            }
        }
        
        if let month = components.month {
            if month == 1 {
                return "In 1 month"
            } else if month > 0 {
                return String(format: NSLocalizedString("In %d months", comment: ""), month)
            } else if month == -1 {
                return String(format: NSLocalizedString("Last month", comment: ""), month)
            } else if month < 0 {
                return String(format: NSLocalizedString("%d months ago", comment: ""), -month)
            }
        }
        
        if let day = components.day {
            if day == 1 {
                return "Tomorrow"
            } else if day > 0 {
                return String(format: NSLocalizedString("In %d days", comment: ""), day)
            } else if day == -1 {
                return "Yesterday"
            } else if day < 0 {
                return String(format: NSLocalizedString("%d days ago", comment: ""), -day)
            }
        }
        
        if let hour = components.hour {
            if hour == 1 {
                return "In 1 hour"
            } else if hour > 0 {
                return String(format: NSLocalizedString("In %d hours", comment: ""), hour)
            } else if hour == -1 {
                return "1 hour ago"
            } else if hour < 0 {
                return String(format: NSLocalizedString("%d hours ago", comment: ""), -hour)
            }
        }
        
        if let minute = components.minute {
            if minute == 1 {
                return "In 1 minute"
            } else if minute > 0 {
                return String(format: NSLocalizedString("In %d minutes", comment: ""), minute)
            } else if minute == -1 {
                return "1 minute ago"
            } else if minute < 0 {
                return String(format: NSLocalizedString("%d minutes ago", comment: ""), -minute)
            }
        }
        
        return NSLocalizedString("Now", comment: "")
    }
    
    /**
     * Format meeting duration
     * - parameter from: From date
     * - parameter to: To date
     * - parameter durationTag: If true, format with duration tag
     * - returns: Formatted string
     */
    static func formatDuration(from: Date, to: Date, durationTag: Bool) -> String {
        let dateComponents = calendar.dateComponents([.hour, .minute], from: from, to: to)
        
        let hour = dateComponents.hour ?? 0
        let minute = dateComponents.minute ?? 0
        
        var hourText = ""
        if hour == 1 {
            hourText = NSLocalizedString("1 hr", comment: "")
        } else if hour > 1 {
            hourText = String(format: NSLocalizedString("%d hrs", comment: ""), hour)
        }
        
        var minuteText = ""
        if minute > 0 {
            minuteText = String(format: NSLocalizedString("%d min", comment: ""), minute)
        }
        
        if durationTag {
            if minuteText.isEmpty {
                return String(format: NSLocalizedString("Duration: %1$@", comment: ""), hourText)
            } else {
                return String(format: NSLocalizedString("Duration: %1$@, %2$@", comment:""), hourText, minuteText)
            }
        } else {
            if minuteText.isEmpty {
                return String(format: NSLocalizedString("%1$@", comment: ""), hourText)
            } else {
                return String(format: NSLocalizedString("%1$@, %2$@", comment:""), hourText, minuteText)
            }
        }
    }
    
    /**
     * Format start time to end time
     *
     * - parameter start: Start time
     * - parameter end: End time
     * - returns: Formatted string
     */
    static func formatTimes(start: Date, end: Date) -> String {
        let startTimeText = DateFormatters.hmmaFormatter.string(from: start)
        let endTimeText = DateFormatters.hmmaFormatter.string(from: end)
        return String(format:NSLocalizedString("%1$@ → %2$@", comment: "Create event start time to end time"), startTimeText, endTimeText)
    }
}
