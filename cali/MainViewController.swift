//
//  ViewController.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit
import Layouts

class MainViewController: UIViewController, UIGestureRecognizerDelegate, EventListViewDelegate, CalendarViewDelegate, LayoutSelectorViewDelegate {
    let weekdayBar = WeekdayBar()
    let calendarView = CalendarView()
    let eventListView = EventListView()
    let contentView = UIView()
    let layoutSelector = LayoutSelectorView()
    let layoutSelectorBackgroundView = UIView()
    let dayView = DayView()
    
    var layoutSelectorLayout : LayoutBuilder?
    
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
        dayView.startDay = selectedDate
        } }
    
    
    var layoutType: LayoutSelectorView.LayoutType = .agenda {
        didSet { updateLayout() }
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
        
        updateLayout()
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
    
    // MARK: CalendarViewDelegate
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
    
    @objc func layoutSelectorBackgroundViewTapped() {
        hideLayoutSelector()
    }
    
    // MARK: LayoutSelectorViewDelegate
    
    func layoutSelectorViewDidChange(_ view: LayoutSelectorView) {
        hideLayoutSelector()
        if (self.layoutType != layoutSelector.selectedType) {
            self.layoutType = layoutSelector.selectedType
        }
    }
    
    var currentContentViewChild : UIView?
    func updateLayout() {
        switch layoutType {
        case .agenda:
            currentContentViewChild?.removeFromSuperview()
            layout(eventListView).matchParent(contentView).install()
            currentContentViewChild = eventListView
        case .day:
            currentContentViewChild?.removeFromSuperview()
            layout(dayView).matchParent(contentView).install()
            currentContentViewChild = dayView
            break
        }
    }
}

