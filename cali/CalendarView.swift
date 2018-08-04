//
//  CalendarView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class CalendarDates {
    let calendar: Calendar
    let startDate: Date?
    let numDates: Int
    
    init(today: Date, calendar: Calendar) {
        self.calendar = calendar
        let weekday = 1 // Sunday
        let sundayComponents = DateComponents(calendar: calendar, weekday: weekday)
        
        let thisSunday = calendar.nextDate(after: today, matching: sundayComponents, matchingPolicy: .nextTime, repeatedTimePolicy: .first, direction: .backward)!
        
        let settings = Settings.instance;
        
        startDate = calendar.date(byAdding: .day,
                                  value: -settings.numWeeksBackwards * 7,
                                  to: thisSunday)
        numDates = (settings.numWeeksBackwards + settings.numWeeksForward) * 7
    }

    func getDate(indexPath: IndexPath) -> Date? {
        guard let startDate = self.startDate else { return nil }
        return calendar.date(byAdding: .day, value: indexPath.row, to: startDate)
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
    
    private static let dayFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "d";
        return formatter
    }()
    
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

        Layouts.stack(self).addChild(
            Layouts.item(collectionView)
                .width(LayoutSize.MatchParent)
                .height(LayoutSize.MatchParent)
        ).install()
        
        let width = totalWidth / 7.0
        layout.itemSize = CGSize(width: width, height: width)
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
        dates = CalendarDates(today: today, calendar: calendar)
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        
        if let date = dates?.getDate(indexPath: indexPath) {
            cell.label.text = CalendarView.dayFormatter.string(from: date)
        } else {
            // ??
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates?.numDates ?? 0
    }
}
