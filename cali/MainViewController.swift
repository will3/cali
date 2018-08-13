//
//  ViewController.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit
import Layouts
import CoreLocation

/// Main view controller
class MainViewController: UIViewController {
    /// Week day bar
    private let weekdayBar = WeekdayBar()
    /// Calendar view
    private let calendarView = CalendarView()
    /// Event list view
    private let eventListView = EventListView()
    /// Content view
    private let contentView = UIView()
    /// Layout selector
    private let layoutSelector = LayoutSelectorView()
    /// Layout selector background
    private let layoutSelectorBackgroundView = UIView()
    /// Day view
    private let dayView = DayView()
    /// Calendar animated
    private let todayButton = TodayButton()
    /// Layout for layout selector
    private var layoutSelectorLayout : LayoutBuilder?
    /// Layout selector shown
    private var layoutSelectorShown = false
    /// Layout for calendar
    private var calendarLayout : LayoutBuilder?
    /// Is calendar view expanded
    private var isCalendarViewExpanded = false
    /// Location service
    private let locationService = Injection.defaultContainer.locationService
    /// Current content view child
    private var currentContentViewChild : UIView?
    /// Weather service
    let weatherService = Injection.defaultContainer.weatherService
    /// Calendar
    let calendar = Injection.defaultContainer.calendar
    var lastWeatherUpdateTime : Date?
    let nowProvider = Injection.defaultContainer.nowProvider

    /// Location
    private var location: CLLocation? {
        didSet {
            updateWeather()
        }
    }

    /// Weather forecast
    
    private var weatherForecast: weatherForecastResponse? {
        didSet {
            calendarView.weatherForecast = weatherForecast
            eventListView.weatherForecast = weatherForecast
            dayView.weatherForecast = weatherForecast
        }
    }

    /// Dates
    private var dates = CalendarDates() { didSet {
        calendarView.dates = dates
        eventListView.dates = dates
        todayButton.today = dates.today
        } }
    
    /// Selected date
    private var selectedDate: Date? { didSet {
        calendarView.selectedDate = selectedDate
        eventListView.selectedDate = selectedDate
        dayView.startDay = selectedDate
        updateNavigationItemTitle()
        } }

    /// Layout
    private var layoutType: LayoutSelectorView.LayoutType = .agenda {
        didSet {
            updateLayout()
            updateRightBarButtons() }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.addSubview(calendarView)
        view.addSubview(contentView)
        view.addSubview(layoutSelectorBackgroundView)
        view.addSubview(layoutSelector)
        view.addSubview(weekdayBar)
        
        layoutSelector.delegate = self
        
        layoutSelectorBackgroundView.backgroundColor = Colors.fadeBackgroundColor
        layoutSelectorBackgroundView.alpha = 0.0
        layout(layoutSelectorBackgroundView).matchParent(view).install()
        layoutSelectorBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action:#selector(MainViewController.layoutSelectorBackgroundViewTapped)))
        
        view.backgroundColor = UIColor.white
        calendarView.delegate = self
        
        eventListView.delegate = self
        
        
        let calendarLayout = layout(calendarView).height(calendarView.preferredCollapsedHeight)
        self.calendarLayout = calendarLayout
        
        dayView.viewController = self
        
        layout(view)
            .translatesAutoresizingMaskIntoConstraints()
            .useTopMarginGuide()
            .useBottomMarginGuide()
            .stack(
                [ layout(weekdayBar),
                  calendarLayout,
                  layout(contentView) ]
            ).install()
        
        layoutSelectorLayout = layout(layoutSelector).parent(view).pinLeft().pinRight().pinTop(
            weekdayBar.preferredHeight - layoutSelector.preferredHeight)
        layoutSelectorLayout?.install()
        
        let calendarPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPanCalendar))
        calendarView.addGestureRecognizer(calendarPan)
        calendarPan.delegate = self
        
        let eventsPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPanEvents))
        eventListView.scrollView.addGestureRecognizer(eventsPan)
        eventListView.viewController = self
        
        eventsPan.delegate = self
        
        let dayViewPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPanDayView))
        dayView.scrollView.addGestureRecognizer(dayViewPan)
        dayViewPan.delegate = self
        
        self.dates = CalendarDates()
        
        if selectedDate == nil {
            selectedDate = self.dates.today
        }
        
        weekdayBar.superview?.bringSubview(toFront: weekdayBar)
        
        updateLayout()
        
        updateRightBarButtons()
        
        updateLeftBarButtons()
        
        todayButton.button.addTarget(self, action: #selector(MainViewController.didTapCalendar), for: .touchUpInside)

        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.didUpdateLocation), name: LocationServiceNotifications.didUpdate, object: nil)
        
        locationService.ensureLocation(from: self)
        
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        
        AccessibilityIdentifier.set(viewController: self, identifier: AccessibilityIdentifier.mainView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(MainViewController.didBecomeActive), name: .UIApplicationDidBecomeActive, object: nil)
    }
        
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventListView.reloadData()
    }
    
    @objc func didBecomeActive() {
        updateWeatherHourly()
        updateToday()
    }
    
    @objc private func didUpdateLocation() {
        location = locationService.location
    }
    
    @objc private func didTapCalendar() {
        selectedDate = self.dates.today
        calendarView.scrollToSelectedDate()
        eventListView.scrollToSelectedDate()
    }
    
    private func updateRightBarButtons() {
        let plusButton = UIBarButtonItem(image: Images.plus, style: .plain, target: self, action: #selector(MainViewController.plusPressed))
        let rightButtons = [
            plusButton,
            UIBarButtonItem(image: layoutTypeImage, style: .plain, target: self, action: #selector(MainViewController.layoutPressed))
        ]
        
        plusButton.accessibilityIdentifier = AccessibilityIdentifier.plusButton
        
        navigationItem.rightBarButtonItems = rightButtons
    }
    
    private func updateLeftBarButtons() {
        todayButton.frame = CGRect(x: 0, y: 0, width: 24, height: 24)
        let leftItem = UIBarButtonItem(customView: todayButton)
        
        leftItem.accessibilityElements = [
            todayButton.button
        ]
        
        todayButton.button.accessibilityIdentifier = AccessibilityIdentifier.todayButton
        
        navigationItem.leftBarButtonItem = leftItem
    }
    
    private var layoutTypeImage : UIImage? {
        var image : UIImage?
        switch layoutType {
        case .agenda:
            image = Images.agenda
        case .day:
            image = Images.day
        }
        return image
    }
    
    @objc private func layoutPressed() {
        if layoutSelectorShown {
            hideLayoutSelector()
        } else {
            showLayoutSelector()
        }
    }
    
    @objc private func plusPressed() {
        guard let selectedDate = self.selectedDate else { return }
        let vc = CreateEventViewController()
        
        vc.createEvent(start: selectedDate.addingTimeInterval(TimeIntervals.hour * 12), duration: TimeIntervals.hour)
        
        let nav = UINavigationController(rootViewController: vc)
        NavigationBars.style(navigationBar: nav.navigationBar, .white)
        present(nav, animated: true, completion: nil)
    }
    
    private func updateNavigationItemTitle() {
        if let selectedDate = self.selectedDate {
            let now = Injection.defaultContainer.nowProvider.now
            let yearA = calendar.dateComponents([.year], from: selectedDate).year
            let yearB = calendar.dateComponents([.year], from: now).year
            
            if yearA == yearB {
                self.navigationItem.title = DateFormatters.LLLLFormatter.string(from: selectedDate)
            } else {
                self.navigationItem.title = DateFormatters.LLLLyyyyFormatter.string(from: selectedDate)
            }
        }
    }
    
    @objc private func didPanCalendar() {
        expandCalendarView()
    }
    
    @objc private func didPanEvents() {
        collapseCalendarView()
    }
    
    @objc private func didPanDayView() {
        collapseCalendarView()
    }

    // MARK: Calendar view

    private func expandCalendarView() {
        if (isCalendarViewExpanded) {
            UIView.animate(withDuration: 0.2) {
                self.calendarLayout?
                    .height(self.calendarView.preferredExpandedHeight)
                    .reinstall()
                self.view.layoutIfNeeded()
            }
        }
        
        isCalendarViewExpanded = true
    }
    
    private func collapseCalendarView() {
        if (!isCalendarViewExpanded) {
            UIView.animate(withDuration: 0.2) {
                self.calendarLayout?
                    .height(self.calendarView.preferredCollapsedHeight)
                    .reinstall()
                self.view.layoutIfNeeded()
            }
            
            calendarView.scrollToSelectedDate()
        }
        
        isCalendarViewExpanded = false
    }
    
    // MARK: Layout selector
    
    private func showLayoutSelector() {
        if layoutSelectorShown {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutSelectorLayout?
                .pinTop(self.weekdayBar.preferredHeight)
                .reinstall()
            self.view.layoutIfNeeded()
            
            self.layoutSelectorBackgroundView.alpha = 1.0
        }
        
        layoutSelectorShown = true
    }
    
    private func hideLayoutSelector() {
        if !layoutSelectorShown {
            return
        }
        
        UIView.animate(withDuration: 0.2) {
            self.layoutSelectorLayout?
                .pinTop(self.weekdayBar.preferredHeight -
                    self.layoutSelector.preferredHeight)
                .reinstall()
            self.view.layoutIfNeeded()
            
            self.layoutSelectorBackgroundView.alpha = 0.0
        }
        
        layoutSelectorShown = false
    }
    
    @objc private func layoutSelectorBackgroundViewTapped() {
        hideLayoutSelector()
    }
    
    // MARK: Private

    private func updateLayout() {
        switch layoutType {
        case .agenda:
            currentContentViewChild?.removeFromSuperview()
            layout(eventListView).matchParent(contentView).install()
            currentContentViewChild = eventListView
            self.contentView.accessibilityElements = [ self.eventListView.tableView ]
        case .day:
            currentContentViewChild?.removeFromSuperview()
            layout(dayView).matchParent(contentView).install()
            currentContentViewChild = dayView
            self.contentView.accessibilityElements = [ self.dayView ]
            break
        }
    }
    
    private func updateWeatherHourly() {
        if lastWeatherUpdateTime == nil ||
            nowProvider.now.timeIntervalSince(lastWeatherUpdateTime!) > TimeIntervals.hour {
            updateWeather()
            lastWeatherUpdateTime = nowProvider.now
        }
    }
    
    private func updateWeather() {
        if let location = self.location {
            if weatherForecast == nil {
                weatherService.getWeather(location: location) { (err, response) in
                    if err != nil {
                        // Reset update timer
                        self.lastWeatherUpdateTime = nil
                        return
                    }
                    
                    self.weatherForecast = response
                }
            }
        }
    }
    
    private func updateToday() {
        if dates.stale {
            dates = CalendarDates()
        }
    }
}

extension MainViewController : UIGestureRecognizerDelegate {
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
}

extension MainViewController : EventListViewDelegate {
    func eventListViewDidScrollToDay(eventListView: EventListView) {
        self.selectedDate = eventListView.firstDay
        calendarView.scrollToSelectedDate()
    }
    
    func eventListViewDidScroll(eventListView: EventListView) {
        if let offset = eventListView.offset {
            todayButton.offset = offset
        }
    }
}

extension MainViewController : CalendarViewDelegate {
    func calendarViewDidChangeSelectedDate(_ calendarView: CalendarView) {
        self.selectedDate = calendarView.selectedDate
        eventListView.scrollToSelectedDate()
    }
}

extension MainViewController : LayoutSelectorViewDelegate {
    func layoutSelectorViewDidChange(_ view: LayoutSelectorView) {
        hideLayoutSelector()
        if (self.layoutType != layoutSelector.selectedType) {
            self.layoutType = layoutSelector.selectedType
        }
    }
}
