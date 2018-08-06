//
//  EventListView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

protocol EventListViewDelegate: AnyObject {
    func eventListViewDidScrollToDay(eventListView: EventListView)
}

class EventListView: UIView, UITableViewDataSource, UITableViewDelegate {
    private var didLoad = false
    private var tableView: UITableView!
    var dates: CalendarDates? { didSet { reloadData() } }
    var selectedDate: Date?
    var calendar = Calendar.current
    var hasScrolledToToday = false
    private(set) var firstDay: Date?
    weak var delegate: EventListViewDelegate?
    
    var scrollView: UIScrollView {
        return tableView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func reloadData() {
        tableView.reloadData()
        tableView.layoutIfNeeded()
        scrollToTodayIfNeeded()
    }
    
    override func didMoveToSuperview() {
        if !didLoad {
            loadView()
            didLoad = true
        }
    }
    
    func loadView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        
        tableView.register(EventListHeaderView.self, forHeaderFooterViewReuseIdentifier: EventListHeaderView.identifier)
        
        layout(tableView).matchParent().install()
        
        tableView.register(EventCell.self, forCellReuseIdentifier: EventCell.identifier)
        
        tableView.showsVerticalScrollIndicator = false
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
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: EventCell.identifier) as! EventCell
        return cell
    }
    
    // MARK: UITableViewDelegate
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = tableView.dequeueReusableHeaderFooterView(withIdentifier: EventListHeaderView.identifier) as! EventListHeaderView
        guard let date = dates?.getDate(index: section) else { return UITableViewCell() }
        headerView.date = date.date
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard let firstVisibleIndexPath = tableView.indexPathsForVisibleRows?.first else {
            return
        }
        
        let firstDay = dates?.getDate(index: firstVisibleIndexPath.section)?.date
        if firstDay != self.firstDay {
            self.firstDay = firstDay
            delegate?.eventListViewDidScrollToDay(eventListView: self)
        }
    }
}
