//
//  ViewController.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, UIGestureRecognizerDelegate, EventListViewDelegate {

    var weekdayBar : WeekdayBar!;
    var calendarView : CalendarView!;
    var eventListView : EventListView!;
    var calendarLayout : LayoutBuilder!
    var isCalendarViewExpanded = false
    var dates: CalendarDates? { didSet {
        calendarView.dates = dates
        eventListView.dates = dates
        } }
    var selectedDate: Date? { didSet {
        calendarView.selectedDate = selectedDate
        eventListView.selectedDate = selectedDate
        } }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        view.backgroundColor = UIColor.white
        
        weekdayBar = WeekdayBar()
        view.addSubview(weekdayBar)
        calendarView = CalendarView()
        view.addSubview(calendarView)
        eventListView = EventListView()
        eventListView.delegate = self
        view.addSubview(eventListView)
        
        calendarLayout = layout(calendarView).height(100)
        
        layoutStack(view)
            .translatesAutoresizingMaskIntoConstraints()
            .useTopMarginGuide(true)
            .useBottomMarginGuide(true)
            .children(
                [ layout(weekdayBar).height(20),
                  calendarLayout,
                  layout(eventListView) ]
            ).install()
        
        let calendarPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPanCalendar))
        calendarView.addGestureRecognizer(calendarPan)
        calendarPan.delegate = self
        
        let eventsPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPanEvents))
        eventListView.scrollView.addGestureRecognizer(eventsPan)
        eventsPan.delegate = self
        
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        if selectedDate == nil {
            selectedDate = today
        }
        self.dates = CalendarDates(today: today, calendar: calendar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        calendarView.startOverlayObservers()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        calendarView.scrollToTodayIfNeeded()
        eventListView.scrollToTodayIfNeeded()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        calendarView.endOverlayObservers()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @objc func didPanCalendar() {
        expandCalendarView()
    }
    
    @objc func didPanEvents() {
        collapseCalendarView()
    }

    func expandCalendarView() {
        if (isCalendarViewExpanded) {
            UIView.animate(withDuration: 0.2) {
                self.calendarLayout.height(200).reinstall()
                self.view.layoutIfNeeded()
            }
        }
        
        isCalendarViewExpanded = true
    }
    
    func collapseCalendarView() {
        if (!isCalendarViewExpanded) {
            UIView.animate(withDuration: 0.2) {
                self.calendarLayout.height(100).reinstall()
                self.view.layoutIfNeeded()
            }
        }
        
        isCalendarViewExpanded = false
    }
    
    // MARK: UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // MARK: EventListViewDelegate
    
    func eventListViewDidScrollToDay(eventListView: EventListView) {
        self.selectedDate = eventListView.firstDay
        calendarView.scrollToSelectedDate()
    }
}

