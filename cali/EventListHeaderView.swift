//
//  EventListHeaderView.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventListHeaderView: UITableViewHeaderFooterView {
    static let identifier = "EventListHeaderView"
    
    private static var dayWeekMonthFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEddMMMM")
        return dateFormatter
    }()
    
    private static var dayWeekMonthYearFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.setLocalizedDateFormatFromTemplate("EEEEddMMMMyyyy")
        return dateFormatter
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private var didLoad = false
    
    var date: Date? { didSet { updateLabel() } }
    var calendar = Container.instance.calendar
    
    var label: UILabel?
    
    override func didMoveToSuperview() {
        if (!didLoad) {
            loadView();
            didLoad = true
        }
    }
    
    func loadView() {
        let label = UILabel()
        self.label = label
        contentView.addSubview(label)
        
        layout(label)
            .left(18)
            .right(18)
            .horizontal(.stretch)
            .vertical(.center)
            .install()
        
        updateLabel()
    }
    
    func updateLabel() {
        guard let date = self.date else { return }
        
        let dateFormatter = calendar.isDate(date, equalTo: Date(), toGranularity: .year) ?
            EventListHeaderView.dayWeekMonthFormatter :
            EventListHeaderView.dayWeekMonthYearFormatter
        
        let dateText = dateFormatter.string(from: date)
        
        let isToday = calendar.isDateInToday(date)
        var firstText: String?
        if calendar.isDateInYesterday(date) {
            firstText = NSLocalizedString("Yesterday", comment: "")
        } else if isToday {
            firstText = NSLocalizedString("Today", comment: "")
        } else if calendar.isDateInTomorrow(date) {
            firstText = NSLocalizedString("Tomorrow", comment: "")
        }
        
        let string = NSMutableAttributedString()
        
        if let text = firstText {
            string.append(
                NSAttributedString(
                    string: "\(text) • ",
                    attributes: [
                        NSAttributedStringKey.font : Fonts.headerFontMedium
                    ]))
        }
        
        string.append(
            NSAttributedString(
                string: dateText,
                attributes: [
                    NSAttributedStringKey.font : Fonts.headerFont
                ]))
        
        label?.attributedText = string

        if isToday {
            contentView.backgroundColor = Colors.lightAccent
            label?.textColor = Colors.accent
        } else {
            contentView.backgroundColor = Colors.dimBackground
            label?.textColor = Colors.primary
        }
    }
}
