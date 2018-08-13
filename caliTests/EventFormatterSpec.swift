//
//  caliTests.swift
//  caliTests
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import XCTest
@testable import cali
import Quick
import Nimble


class Dates {
    static func date(year: Int, month: Int, day: Int, hour: Int, minute: Int, second: Int) -> Date {
        let calendar = Injection.defaultContainer.calendar
        var components = DateComponents()
        components.year = year
        components.month = month
        components.day = day
        components.hour = hour
        components.minute = minute
        components.second = second
        
        return calendar.date(from: components)!
    }
}

class EventFormatterSpec: QuickSpec {
    override func spec() {
        describe("Event formatter") {
            describe("Format relative") {
                it("formats years") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025 + 2, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 2 years"))
                }
                
                it("formats year") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025 + 1, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 1 year"))
                }
                
                it("formats months") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1 + 2, day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 2 months"))
                }
                
                it("formats month") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1 + 1, day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 1 month"))
                }
                
                it("formats days") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1 + 2, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 2 days"))
                }
                
                it("formats day") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1 + 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("Tomorrow"))
                }
                
                it("formats hours") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1 + 2, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 2 hours"))
                }
                
                it("formats hour") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1 + 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 1 hour"))
                }
                
                it("formats minutes") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1 + 2, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 2 minutes"))
                }
                
                it("formats minute") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1 + 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("In 1 minute"))
                }
                
                it("formats now") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1 + 10)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("Now"))
                }

                it("formats years") {
                    let start = Dates.date(year: 2025 + 2, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025 , month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("2 years ago"))
                }
                
                it("formats year") {
                    let start = Dates.date(year: 2025 + 1, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025 , month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("Last year"))
                }
                
                it("formats months") {
                    let start = Dates.date(year: 2025, month: 1 + 2, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1 , day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("2 months ago"))
                }
                
                it("formats month") {
                    let start = Dates.date(year: 2025, month: 1 + 1, day: 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1 , day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("Last month"))
                }
                
                it("formats days") {
                    let start = Dates.date(year: 2025, month: 1, day: 1 + 2, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1 , hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("2 days ago"))
                }
                
                it("formats day") {
                    let start = Dates.date(year: 2025, month: 1, day: 1 + 1, hour: 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1 , hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("Yesterday"))
                }
                
                it("formats hours") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1 + 2, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1 , minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("2 hours ago"))
                }
                
                it("formats hour") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1 + 1, minute: 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1 , minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("1 hour ago"))
                }
                
                it("formats minutes") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1 + 2, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1 , second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("2 minutes ago"))
                }
                
                it("formats minute") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1 + 1, second: 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1 , second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("1 minute ago"))
                }
                
                it("formats now") {
                    let start = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1 + 1)
                    let end = Dates.date(year: 2025, month: 1, day: 1, hour: 1, minute: 1, second: 1)
                    let text = EventFormatter.formatRelative(from: start, to: end)
                    expect(text).to(equal("Now"))
                }
            }
        }
    }
}
