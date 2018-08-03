//
//  ViewController.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var weekdayBar : WeekdayBar!;
    var calendarView : CalendarView!;
    var eventListView : EventListView!;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        weekdayBar = WeekdayBar()
        weekdayBar.backgroundColor = UIColor(red: 0.5, green: 0.0, blue: 0.0, alpha: 1.0)
        view.addSubview(weekdayBar)
        calendarView = CalendarView()
        calendarView.backgroundColor = UIColor(red: 0.0, green: 0.5, blue: 0.0, alpha: 1.0)
        view.addSubview(calendarView)
        eventListView = EventListView()
        eventListView.backgroundColor = UIColor(red: 0.0, green: 0.0, blue: 0.5, alpha: 1.0)
        view.addSubview(eventListView)
        
        Layouts.list(view)
            .useTopMarginGuide(true)
            .useBottomMarginGuide(true)
            .addChildren(
                [ Layouts.item(weekdayBar).height(20),
                  Layouts.item(calendarView).height(100),
                  Layouts.item(eventListView) ]
            ).install()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

