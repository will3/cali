//
//  ViewController.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIGestureRecognizerDelegate {

    var weekdayBar : WeekdayBar!;
    var calendarView : CalendarView!;
    var eventListView : EventListView!;
    var calendarLayout : LayoutBuilder!
    
    var isCalendarViewExpanded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        weekdayBar = WeekdayBar()
        view.addSubview(weekdayBar)
        calendarView = CalendarView()
        view.addSubview(calendarView)
        eventListView = EventListView()
        view.addSubview(eventListView)
        
        calendarLayout = Layouts.item(calendarView).height(100)
        
        Layouts.stack(view)
            .useTopMarginGuide(true)
            .useBottomMarginGuide(true)
            .addChildren(
                [ Layouts.item(weekdayBar).height(20),
                  calendarLayout,
                  Layouts.item(eventListView) ]
            ).install()
        
        let calendarPan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.didPanCalendar))
        calendarView.scrollView.addGestureRecognizer(calendarPan)
        calendarPan.delegate = self
        
        let eventsPan = UIPanGestureRecognizer(target: self, action: #selector(ViewController.didPanEvents))
        eventListView.scrollView.addGestureRecognizer(eventsPan)
        eventsPan.delegate = self
        
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
}

