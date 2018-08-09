//
//  ViewController.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit
import Layouts

class MainViewController: UIViewController, UIGestureRecognizerDelegate, EventListViewDelegate, CalendarViewDelegate {
    let weekdayBar = WeekdayBar()
    let calendarView = CalendarView()
    let eventListView = EventListView()
    let layoutSelector = LayoutSelectorView()
    var layoutSelectorLayout : LayoutBuilder?
    var layoutSelectorBackgroundView = UIView()
    
    var layoutSelectorShown = false
    
    var calendarLayout : LayoutBuilder?
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
        
        view.addSubview(calendarView)
        view.addSubview(eventListView)
        view.addSubview(layoutSelectorBackgroundView)
        view.addSubview(layoutSelector)
        view.addSubview(weekdayBar)
        
        layoutSelectorBackgroundView.backgroundColor = Colors.fadeBackgroundColor
        layoutSelectorBackgroundView.alpha = 0.0
        layout(layoutSelectorBackgroundView).matchParent(view).install()
        
        view.backgroundColor = UIColor.white
        calendarView.delegate = self
        
        eventListView.delegate = self
        
        
        let calendarLayout = layout(calendarView).height(calendarView.preferredCollapsedHeight)
        self.calendarLayout = calendarLayout
        
        layout(view)
            .translatesAutoresizingMaskIntoConstraints()
            .useTopMarginGuide(true)
            .useBottomMarginGuide(true)
            .stack(
                [ layout(weekdayBar),
                  calendarLayout,
                  layout(eventListView) ]
            ).install()
        
        layoutSelectorLayout = layout(layoutSelector).parent(view).pinLeft().pinRight().pinTop(
            weekdayBar.preferredHeight - layoutSelector.preferredHeight)
        layoutSelectorLayout?.install()
        
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
            UIBarButtonItem(image: Images.plus, style: .plain, target: self, action: #selector(MainViewController.plusPressed)),
            UIBarButtonItem(image: Images.plus, style: .plain, target: self, action: #selector(MainViewController.layoutPressed))
        ]
        
        weekdayBar.superview?.bringSubview(toFront: weekdayBar)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        eventListView.reloadData()
    }
    
    @objc func layoutPressed() {
        if layoutSelectorShown {
            hideLayoutSelector()
        } else {
            showLayoutSelector()
        }
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
                self.calendarLayout?
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
                self.calendarLayout?
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
    
    func calendarViewDidChangeSelectedDate(_ calendarView: CalendarView) {
        self.selectedDate = calendarView.selectedDate
        eventListView.scrollToSelectedDate()
    }
    
    // MARK: Layout selector
    
    func showLayoutSelector() {
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
    
    func hideLayoutSelector() {
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
}

