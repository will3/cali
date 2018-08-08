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
    var dates = CalendarDates() { didSet {
        calendarView.dates = dates
        eventListView.dates = dates
        } }
    var selectedDate: Date? { didSet {
        calendarView.selectedDate = selectedDate
        eventListView.selectedDate = selectedDate
        updateNavigationItemTitle()
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
        
        calendarLayout = layout(calendarView).height(calendarView.preferredCollapsedHeight)
        
        layout(view)
            .translatesAutoresizingMaskIntoConstraints()
            .useTopMarginGuide(true)
            .useBottomMarginGuide(true)
            .stack(
                [ layout(weekdayBar),
                  calendarLayout,
                  layout(eventListView) ]
            ).install()
        
        let calendarPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPanCalendar))
        calendarView.addGestureRecognizer(calendarPan)
        calendarPan.delegate = self
        
        let eventsPan = UIPanGestureRecognizer(target: self, action: #selector(MainViewController.didPanEvents))
        eventListView.scrollView.addGestureRecognizer(eventsPan)
        eventsPan.delegate = self
        
        self.dates = CalendarDates()
        
        if selectedDate == nil {
            selectedDate = self.dates.today
        }
        
        navigationItem.rightBarButtonItems = [
            UIBarButtonItem(image: Images.plus, style: .plain, target: self, action: #selector(MainViewController.plusPressed))
        ]
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventListView.reloadData()
    }
    
    @objc func plusPressed() {
        guard let selectedDate = self.selectedDate else { return }
        let vc = CreateEventViewController()
        
        vc.createEvent(start: selectedDate.addingTimeInterval(TimeIntervals.hour * 12), duration: TimeIntervals.hour)
        
        let nav = UINavigationController(rootViewController: vc)
        NavigationBars.style(navigationBar: nav.navigationBar, .white)
        present(nav, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func updateNavigationItemTitle() {
        if let selectedDate = self.selectedDate {
            self.navigationItem.title = DateFormatters.LLLLFormatter.string(from: selectedDate)
        }
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
                self.calendarLayout
                    .height(self.calendarView.preferredExpandedHeight)
                    .reinstall()
                self.view.layoutIfNeeded()
            }
        }
        
        isCalendarViewExpanded = true
    }
    
    func collapseCalendarView() {
        if (!isCalendarViewExpanded) {
            UIView.animate(withDuration: 0.2) {
                self.calendarLayout
                    .height(self.calendarView.preferredCollapsedHeight)
                    .reinstall()
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

