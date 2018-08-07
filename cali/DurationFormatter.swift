//
//  DurationFormatter.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class DurationFormatter {
    static let calendar = Calendar.current
    static func formatRelative(from: Date, to: Date) -> String {
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: from, to: to)
        
        if let year = components.year {
            if year == 1 {
                return "In 1 year"
            } else if year > 0 {
                return String(format: "In %d years", year)
            } else if year == -1 {
                return String(format: "1 year ago", year)
            } else if year < 0 {
                return String(format: "%d years ago", year)
            }
        }
        
        if let month = components.month {
            if month == 1 {
                return "In 1 month"
            } else if month > 0 {
                return String(format: "In %d months", month)
            } else if month == -1 {
                return String(format: "1 month ago", month)
            } else if month < 0 {
                return String(format: "%d months ago", month)
            }
        }
        
        if let week = components.weekOfYear {
            if week == 1 {
                return "In 1 week"
            } else if week > 0 {
                return String(format: "In %d weeks", week)
            } else if week == -1 {
                return "Last week"
            } else if week < 0 {
                return String(format: "%d weeks ago", week)
            }
        }
        
        if let day = components.day {
            if day == 1 {
                return "Tomorrow"
            } else if day > 0 {
                return String(format: "In %d days", day)
            } else if day == -1 {
                return "Yesterday"
            } else if day < 0 {
                return String(format: "%d days ago", day)
            }
        }
        
        if let hour = components.hour {
            if hour == 1 {
                return "In 1 hour"
            } else if hour > 0 {
                return String(format: "In %d hours", hour)
            } else if hour == -1 {
                return "1 hour ago"
            } else if hour < 0 {
                return String(format: "%d hours ago", hour)
            }
        }
        
        if let minute = components.minute {
            if minute == 1 {
                return "In 1 minute"
            } else if minute > 0 {
                return String(format: "In %d minutes", minute)
            } else if minute == -1 {
                return "1 minute ago"
            } else if minute < 0 {
                return String(format: "%d minutes ago", minute)
            }
        }
        
        return NSLocalizedString("Now", comment: "")
    }
    
    static func formatMeetingDuration(from: Date, to: Date) -> String {
        let dateComponents = calendar.dateComponents([.hour, .minute], from: from, to: to)
        
        let hour = dateComponents.hour ?? 0
        let minute = dateComponents.minute ?? 0
        
        var hourText = ""
        if hour == 1 {
            hourText = "1 hr"
        } else if hour > 1 {
            hourText = String(format: NSLocalizedString("%d hrs", comment: ""), hour)
        }
        
        var minuteText = ""
        if minute > 0 {
            minuteText = String(format: NSLocalizedString("%d min", comment: ""), minute)
        }
        
        if minuteText.isEmpty {
            return String(format: NSLocalizedString("Duration: %1$@", comment: ""), hourText)
        } else {
            return String(format: NSLocalizedString("Duration: %1$@, %2$@", comment:""), hourText, minuteText)
        }
    }
}
