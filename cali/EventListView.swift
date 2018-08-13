//
//  EventListView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit
import Layouts

protocol EventListViewDelegate: AnyObject {
    func eventListViewDidScrollToDay(eventListView: EventListView)
    func eventListViewDidScroll(eventListView: EventListView)
}

/// Event list view
class EventListView: UIView, UITableViewDataSource, UITableViewDelegate {
    /// Dates
    var dates: CalendarDates? { didSet { reloadData() } }
    /// Selected date
    var selectedDate: Date?
    /// View controller
    weak var viewController: UIViewController?
    /// First day
    private(set) var firstDay: Date?
    /// Has scrolled to today
    private var hasScrolledToToday = false
    /// View did load
    private var didLoad = false
    /// Table view
    let tableView = UITableView()
    /// Calendar
    private let calendar = Injection.defaultContainer.calendar
    /// Delegate
    weak var delegate: EventListViewDelegate?
    /// Event service
    private let eventService = Injection.defaultContainer.eventService
    /// Weather forecast
    var weatherForecast : weatherForecastResponse? { didSet { updateWeather() } }
    /// Is scrolling to selected date
    private(set) var isScrollingToSelectedDate = false
    
    var offset: CGFloat? {
        guard let dates = self.dates else { return nil }
        let indexPath = IndexPath(row: 0, section: dates.indexForToday)
        let rect = tableView.rectForRow(at: indexPath)
        return tableView.contentOffset.y - rect.origin.y
    }
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func reloadData() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        scrollToTodayIfNeeded()
    }
    
    override func didMoveToSuperview() {
        if !didLoad {
            loadView()
            didLoad = true
        }
    }
    
    func loadView() {
        tableView.separatorColor = Colors.separator
        tableView.separatorInset = UIEdgeInsets.zero
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        
        tableView.register(EventListHeaderView.self, forHeaderFooterViewReuseIdentifier: EventListHeaderView.identifier)
        
        layout(tableView).matchParent().install()
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        tableView.register(EventEmptyCell.self, forCellReuseIdentifier: EventEmptyCell.identifier)
        
        tableView.showsVerticalScrollIndicator = false
        
        self.isAccessibilityElement = true
        self.accessibilityIdentifier = AccessibilityIdentifier.eventListView
        
        tableView.accessibilityIdentifier = AccessibilityIdentifier.eventTableView
    }
    
    private func scrollToTodayIfNeeded() {
        guard let dates = self.dates else { return }
        if !hasScrolledToToday {
            let index = dates.indexForToday
            let indexPath = IndexPath(row: 0, section: index)
            tableView.scrollToRow(at: indexPath, at: .top, animated: true)
            
            hasScrolledToToday = true
        }
    }
    
    // MARK: UITableViewDataSource
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dates?.numDates ?? 0
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let date = dates?.getDate(index: section) else { return 0 }
        let events = eventService.find(startDay: date.date)
        if events.count == 0 {
            return 1
        } else {
            return events.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let date = dates?.getDate(index: indexPath.section) else { return UITableViewCell() }
        let events = eventService.find(startDay: date.date)
        
        if events.count == 0 {
            return tableView.dequeueReusableCell(withIdentifier: EventEmptyCell.identifier, for: indexPath)
        } else {
            let eventCell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier, for: indexPath) as! EventCell
            eventCell.event = events[indexPath.row]
            return eventCell
        }
    }
    
    // MARK: UITableViewDelegate
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventListHeaderView.identifier) as! EventListHeaderView
        guard let date = dates?.getDate(index: section) else { return UITableViewCell() }
        headerView.date = date.date
        headerView.weatherIcon = weatherForecast?.getForecast(dateUTC: date.dateUTC)?.icon
        headerView.weatherButton.addTarget(self, action: #selector(EventListView.didPressWeatherButton(sender:)), for: .touchUpInside)
        return headerView
    }
    
    @objc func didPressWeatherButton(sender: EventListHeaderView) {
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        if let date = dates?.getDate(index: indexPath.section) {
            let events = eventService.find(startDay: date.date)
            if events.count > 0 {
                let event = events[indexPath.row]
                
                let vc = CreateEventViewController()
                vc.editEvent(event)
                self.viewController?.navigationController?.pushViewController(vc, animated: true)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.delegate?.eventListViewDidScroll(eventListView: self)
        
        if let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first {
            let firstDay = dates?.getDate(index: firstVisibleIndexPath.section)?.date
            if firstDay != self.firstDay {
                self.firstDay = firstDay
                if !isScrollingToSelectedDate {
                    delegate?.eventListViewDidScrollToDay(eventListView: self)
                }
            }
        }
    }
    
    func scrollToSelectedDate() {
        guard let dates = self.dates else { return }
        guard let selectedDate = self.selectedDate else { return }
        let index = dates.getIndex(date: selectedDate)
        let indexPath = IndexPath(row: 0, section: index)
        tableView.scrollToRow(at: indexPath, at: .top, animated: true)
        
        isScrollingToSelectedDate = true
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        isScrollingToSelectedDate = false
    }

    func updateWeather() {
        tableView.reloadData()
    }
    
}
