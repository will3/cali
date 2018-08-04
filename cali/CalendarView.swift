//
//  CalendarView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class CalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    var scrollView: UIScrollView {
        return collectionView
    }
    private var collectionView: UICollectionView!
    private var layout: UICollectionViewFlowLayout!
    private var didLoad = false
    var hasScrolledToToday = false
    
    var totalWidth: CGFloat = UIScreen.main.bounds.size.width { didSet { reloadData() } }
    var dates: CalendarDates? { didSet { reloadData() } }
    var selectedDate: Date? { didSet { updateSelectedDate() } }
    
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
        
        self.addSubview(collectionView)

        Layouts.view(collectionView).matchParent().install()
        
        let width = totalWidth / 7.0
        layout.itemSize = CGSize(width: width, height: width + 4.0)
        layout.minimumLineSpacing = 0
        layout.minimumInteritemSpacing = 0

        collectionView.register(
            UINib.init(nibName: CalendarCollectionViewCell.identifier, bundle: Bundle.main),
            forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
    }
    
    func scrollToTodayIfNeeded() {
        if hasScrolledToToday {
            return
        }
        guard let dates = self.dates else { return }
        let indexPath = IndexPath(item: dates.indexForToday, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        hasScrolledToToday = true
    }
    
    func scrollToSelectedDate() {
        guard let selectedDate = self.selectedDate else { return }
        guard let dates = self.dates else { return }
        
        let indexPath = IndexPath(item: dates.getIndex(date: selectedDate), section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    private func reloadData() {
        collectionView.reloadData()
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        
        update(calendarCell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func update(calendarCell: CalendarCollectionViewCell, indexPath: IndexPath) {
        let dates = self.dates!
        let date = dates.getDate(index: indexPath.item)!
        
        calendarCell.day = date.formattedDay
        let selected = date.date == selectedDate
        if date.day == 1 && !selected {
            calendarCell.month = date.formattedMonth
        } else {
            calendarCell.month = ""
        }
        
        calendarCell.isPast = dates.isPastMonth(date: date.date)
        calendarCell.shouldShowCircle = selected
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates?.getDate(index: indexPath.item)?.date
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates?.numDates ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let calendarCell = cell as? CalendarCollectionViewCell {
            update(calendarCell: calendarCell, indexPath: indexPath)
        }
    }
    
    func updateSelectedDate() {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let calendarCell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
                update(calendarCell: calendarCell, indexPath: indexPath)
            }
        }
    }
}
