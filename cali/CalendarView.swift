//
//  CalendarView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

protocol CalendarViewDelegate : AnyObject {
    func calendarViewDidChangeSelectedDate(_ calendarView: CalendarView)
}

class CalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    private let overlay = MonthOverlayView()
    private var didLoad = false
    var hasScrolledToToday = false
    var totalWidth: CGFloat = UIScreen.main.bounds.size.width
    weak var delegate: CalendarViewDelegate?
    
    var dates = CalendarDates() {
        didSet {
            overlay.dates = dates
            reloadData()
        }
    }
    
    var selectedDate: Date? {
        didSet {
            updateSelectedDate()
        }
    }
    
    var itemSize: CGSize {
        return CalendarView.itemSizeForWidth(totalWidth)
    }
    
    static func itemSizeForWidth(_ totalWidth: CGFloat) -> CGSize {
        let width = totalWidth / 7.0
        return CGSize(width: width, height: width + 4.0)
    }
    
    var preferredCollapsedHeight : Float {
        return Float(itemSize.height * 2)
    }
    
    var preferredExpandedHeight : Float {
        return Float(itemSize.height * 5)
    }
    
    private func startOverlayObservers() {
        collectionView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentOffset") {
            overlay.setContentOffset(collectionView.contentOffset)
        }
    }
    
    private func endOverlayObservers() {
        collectionView.removeObserver(self, forKeyPath: "contentOffset")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        if !didLoad {
            loadView()
            didLoad = true
        }
        
        if superview == nil {
            endOverlayObservers()
        } else {
            startOverlayObservers()
        }
    }
    
    private func loadView() {
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.white
        collectionView.showsVerticalScrollIndicator = false
        collectionView.scrollsToTop = false
        
        addSubview(collectionView)

        Layouts.view(collectionView).matchParent().install()
        
        if let flowLayout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.itemSize = itemSize
            flowLayout.minimumLineSpacing = 0
            flowLayout.minimumInteritemSpacing = 0
        }
        
        overlay.rowHeight = itemSize.height
        addSubview(overlay)
        layout(overlay).matchParent().install()

        collectionView.register(
            UINib.init(nibName: CalendarCollectionViewCell.identifier, bundle: Bundle.main),
            forCellWithReuseIdentifier: CalendarCollectionViewCell.identifier)
        
        reloadData()
    }
    
    private func scrollToTodayIfNeeded() {
        if hasScrolledToToday {
            return
        }
        let indexPath = IndexPath(item: dates.indexForToday, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        hasScrolledToToday = true
    }
    
    func scrollToSelectedDate() {
        guard let selectedDate = self.selectedDate else { return }
        
        let indexPath = IndexPath(item: dates.getIndex(date: selectedDate), section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    private func reloadData() {
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollToTodayIfNeeded()
    }
    
    func updateSelectedDate() {
        for indexPath in collectionView.indexPathsForVisibleItems {
            if let calendarCell = collectionView.cellForItem(at: indexPath) as? CalendarCollectionViewCell {
                update(calendarCell: calendarCell, indexPath: indexPath)
            }
        }
    }
    
    // MARK: UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CalendarCollectionViewCell.identifier, for: indexPath) as! CalendarCollectionViewCell
        
        update(calendarCell: cell, indexPath: indexPath)
        
        return cell
    }
    
    func update(calendarCell: CalendarCollectionViewCell, indexPath: IndexPath) {
        let date = dates.getDate(index: indexPath.item)!
        
        calendarCell.day = date.formattedDay
        let selected = date.date == selectedDate
        if date.day == 1 && !selected {
            calendarCell.month = date.formattedMonth
        } else {
            calendarCell.month = ""
        }
        
        if dates.isPastMonth(date: date.date) {
            calendarCell.background = .Past
        } else if dates.isToday(date: date.date) {
            calendarCell.background = .Today
        } else {
            calendarCell.background = .Default
        }
        calendarCell.shouldShowCircle = selected
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedDate = dates.getDate(index: indexPath.item)?.date
        collectionView.reloadData()
        
        delegate?.calendarViewDidChangeSelectedDate(self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dates.numDates
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let calendarCell = cell as? CalendarCollectionViewCell {
            update(calendarCell: calendarCell, indexPath: indexPath)
        }
    }
    
    // MARK: UIScrollViewDelegate
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        showOverlay()
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if (velocity.y == 0) {
            hideOverlay()
            // snap
            let y = targetContentOffset.pointee.y
            let desiredY = round(y / itemSize.height) * itemSize.height
            let contentOffset = CGPoint(x: 0, y: desiredY)
            scrollView.setContentOffset(contentOffset, animated: true)
        } else {
            let y = targetContentOffset.pointee.y
            let desiredY = round(y / itemSize.height) * itemSize.height
            targetContentOffset.pointee = CGPoint(x: 0, y: desiredY)
        }
    }
    
    func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        hideOverlay()
    }
    
    // MARK: Overlay
    
    func showOverlay() {
        UIView.animate(withDuration: 0.2) {
            self.overlay.alpha = 1.0
        }
    }
    
    func hideOverlay() {
        UIView.animate(withDuration: 0.2) {
            self.overlay.alpha = 0.0
        }
    }
}
