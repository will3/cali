//
//  CalendarView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit
import Layouts

protocol CalendarViewDelegate : AnyObject {
    func calendarViewDidChangeSelectedDate(_ calendarView: CalendarView)
}

/// Calendar View
class CalendarView: UIView, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    /// Collection view
    private let collectionView = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewFlowLayout())
    /// Overlay
    private let overlay = MonthOverlayView()
    /// Did load view
    private var didLoad = false
    /// Has scrolled to today
    private var hasScrolledToToday = false
    /// Delegate
    weak var delegate: CalendarViewDelegate?
    /// Total width of view, set this before adding to superview
    var totalWidth: CGFloat = UIScreen.main.bounds.size.width
    /// Event service
    private let eventService = Injection.defaultContainer.eventService
    /// Weather forecast, set this to show weather forecasts
    var weatherForecast: WeatherForecastResponse? { didSet { updateWeather() } }
    /// Dates to display
    var dates = CalendarDates() {
        didSet {
            overlay.dates = dates
            reloadData()
        }
    }
    
    /// Selected date
    var selectedDate: Date? {
        didSet {
            updateSelectedDate()
        }
    }
    
    /// Item size
    var itemSize: CGSize {
        return CalendarView.itemSizeForWidth(totalWidth)
    }
    
    /**
     * Given total width, calculate item size
     * 
     * - param totalWidth: Total width
     * - returns: item size
     */
    static func itemSizeForWidth(_ totalWidth: CGFloat) -> CGSize {
        let width = totalWidth / 7.0
        return CGSize(width: width, height: width + 4.0)
    }
    
    /// Preferred collapsed height
    var preferredCollapsedHeight : Float {
        return Float(itemSize.height * 2)
    }
    
    /// Preferred expanded height
    var preferredExpandedHeight : Float {
        return Float(itemSize.height * 5)
    }
    
    /// Start overlay observers
    private func startOverlayObservers() {
        collectionView.addObserver(self, forKeyPath: "contentOffset", options: .new, context: nil)
    }
    
    override func observeValue(forKeyPath keyPath: String?, of object: Any?, change: [NSKeyValueChangeKey : Any]?, context: UnsafeMutableRawPointer?) {
        if (keyPath == "contentOffset") {
            overlay.setContentOffset(collectionView.contentOffset)
        }
    }
    
    /// End overlay observers
    private func endOverlayObservers() {
        collectionView.removeObserver(self, forKeyPath: "contentOffset")
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
    
    /// Scroll to today if needed
    private func scrollToTodayIfNeeded() {
        if hasScrolledToToday {
            return
        }
        let indexPath = IndexPath(item: dates.indexForToday, section: 0)
        collectionView.scrollToItem(at: indexPath, at: .top, animated: false)
        hasScrolledToToday = true
    }
    
    /// Scroll to selected date
    func scrollToSelectedDate() {
        guard let selectedDate = self.selectedDate else { return }
        
        let indexPath = IndexPath(item: dates.getIndex(date: selectedDate), section: 0)
        collectionView.scrollToItem(at: indexPath, at: .bottom, animated: true)
    }
    
    /// Reload data
    private func reloadData() {
        collectionView.reloadData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        scrollToTodayIfNeeded()
    }
    
    /// Update selected date
    private func updateSelectedDate() {
        redrawVisibileCells()        
    }

    /// Redraw visible cells
    private func redrawVisibileCells() {
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

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = self.itemSize
        if indexPath.row % 7 == 6 {
            let width = floor(totalWidth - 6 * floor(itemSize.width))
            return CGSize(width: width, height: itemSize.height)
        } else {
            let width = floor(itemSize.width)
            return CGSize(width: width, height: itemSize.height)
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
    
    /**
     * Update calendar cell
     * 
     * - param calendarCell: Calendar Cell
     * - param indexPath: Index path
     */
    private func update(calendarCell: CalendarCollectionViewCell, indexPath: IndexPath) {
        let date = dates.getDate(index: indexPath.item)!
        
        calendarCell.day = date.formattedDay
        let selected = date.date == selectedDate
        if date.day == 1 && !selected {
            calendarCell.month = date.formattedMonth
        } else {
            calendarCell.month = ""
        }
        
        if dates.isToday(date: date.date) {
            calendarCell.background = .today
        } else if dates.isEvenNumberOfMonth(date: date.date) {
            calendarCell.background = .white
        } else {
            calendarCell.background = .grey
        }
        
        calendarCell.shouldShowCircle = selected
        calendarCell.numEvents = eventService.find(startDay: date.date).count
        
        if let weatherData = weatherForecast?.getWeather(dateUTC: date.dateUTC) {
            calendarCell.weatherIcon = weatherData.icon
        } else {
            calendarCell.weatherIcon = nil
        }
        
        let todayIndex = dates.indexForToday
        let index = indexPath.row
        
        if index == todayIndex {
            calendarCell.shouldDrawLeftBorder = true
        }
        
        let lastWeekToday = todayIndex - 7
        
        calendarCell.shouldDrawBotBorder = false
        calendarCell.shouldDrawLeftBorder = false
        
        if index >= lastWeekToday && index < todayIndex {
            calendarCell.shouldDrawBotBorder = true
        } else if index == todayIndex {
            calendarCell.shouldDrawLeftBorder = true
        }
    }

    
    /// Update weather
    private func updateWeather() {
        reloadData()
    }
}
