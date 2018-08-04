//
//  CalendarView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

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
        return CalendarFormatters.shortMonthFormatter.string(from: date)
    }
    
    init(date: Date, calendar: Calendar) {
        self.date = date
        self.calendar = calendar
    }
}

class CalendarFormatters {
    static let shortMonthFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "LLL";
        return formatter
    }()
}

class CalendarDates {
    let calendar: Calendar
    let startDate: Date?
    let numDates: Int
    let today: Date
    let startOfMonth: Date?
    
    init(today: Date, calendar: Calendar) {
        self.today = today
        self.calendar = calendar
        let weekday = 1 // Sunday
        let sundayComponents = DateComponents(calendar: calendar, weekday: weekday)
        
        let thisSunday = calendar.nextDate(after: today, matching: sundayComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)!
        
        let settings = Settings.instance;
        
        startDate = calendar.date(byAdding: .day,
                                  value: -settings.numWeeksBackwards * 7,
                                  to: thisSunday)
        numDates = (settings.numWeeksBackwards + settings.numWeeksForward) * 7
        
        let startOfMonthComponents = calendar.dateComponents([ .year, .month ], from: today)
        startOfMonth = calendar.date(from: startOfMonthComponents)
    }

    func getDate(indexPath: IndexPath) -> CalendarDate? {
        guard let startDate = self.startDate else { return nil }
        guard let date = calendar.date(byAdding: .day, value: indexPath.row, to: startDate) else { return nil }
        
        return CalendarDate(date: date, calendar: calendar)
    }
    
    func isPastMonth(date: Date) -> Bool {
        guard let startOfMonth = self.startOfMonth else { return false }
        return date.compare(startOfMonth) == .orderedAscending
    }
    
    var indexPathForToday: IndexPath {
        let settings = Settings.instance;
        return IndexPath(item: settings.numWeeksBackwards * 7, section: 0)
    }
}

class CalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var scrollView: UIScrollView {
        return collectionView
    }
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var totalWidth: CGFloat = 0
    private var didLoad = false
    private var dates: CalendarDates?
    var selectedDate: Date?
    var hasScrolledToToday = false
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        if didLoad { return }

        loadView()
        
        didLoad = true
    }
    
    private func loadView() {
        layout = UICollectionViewFlowLayout()
        collectionView = UICollectionView(frame: frame, collectionViewLayout: layout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        totalWidth = UIScreen.main.bounds.size.width
        
        self.addSubview(collectionView)

        Layouts.view(collectionView).matchParent().install()
        
        let width = totalWidth / 7.0
        layout.itemSize = CGSize(width: width, height: width + 4.0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        collectionView.register(
            UINib.init(nibName: CalendarCollectionViewCell.identifier, bundle: Bundle.main),
            forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        
        reloadData()
    }
    
    func reloadData() {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if selectedDate == nil {
            selectedDate = today
        }
        let dates = CalendarDates(today: today, calendar: calendar)
        self.dates = dates
        
        collectionView.reloadData()
    }
    
    func scrollToTodayIfNeeded() {
        if hasScrolledToToday {
            return
        }
        guard let dates = self.dates else { return }
        collectionView.scrollToItem(at: dates.indexPathForToday, at: .top, animated: false)
        hasScrolledToToday = true
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        
        let dates = self.dates!
        let date = dates.getDate(indexPath: indexPath)!
        
        cell.label?.text = date.formattedDay
        let selected = date.date == selectedDate
        if date.day == 1 && !selected {
            cell.monthLabel?.text = date.formattedMonth
        } else {
            cell.monthLabel?.text = ""
        }
        cell.shouldShowCircle = selected
        cell.isPast = dates.isPastMonth(date: date.date)
        
        cell.contentView.alpha = hasScrolledToToday ? 1.0 : 0.0
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates?.getDate(indexPath: indexPath)?.date
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates?.numDates ?? 0
    }
}
