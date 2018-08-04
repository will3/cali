//
//  MonthOverlayView.swift
//  cali
//
//  Created by will3 on 4/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class MonthOverlayView : UIView, UITableViewDataSource, UITableViewDelegate {
    static let monthNameFormmater : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "MMMM"
        return formatter
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    var didLoad = false
    let tableView = UITableView()
    var dates: CalendarDates? { didSet { tableView.reloadData() } }
    var rowHeight = CGFloat(42.0)
    
    func setContentOffset(_ contentOffset: CGPoint) {
        tableView.contentOffset = contentOffset
    }
    
    override func didMoveToSuperview() {
        if !didLoad {
            loadView()
            didLoad = true
        }
    }
    
    func loadView() {
        addSubview(tableView)
        layout(tableView).matchParent().install()
        
        tableView.register(MonthOverlayCell.self, forCellReuseIdentifier: MonthOverlayCell.identifier)
        tableView.dataSource = self
        tableView.delegate = self
        
        backgroundColor = UIColor.clear
        tableView.backgroundColor = UIColor.clear
        tableView.separatorStyle = .none
        tableView.estimatedRowHeight = rowHeight
        
        isUserInteractionEnabled = false
        self.alpha = 0.0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: MonthOverlayCell.identifier, for: indexPath) as? MonthOverlayCell else {
            return UITableViewCell()
        }
        guard let dates = self.dates else { return UITableViewCell() }
        
        
        if let date = dates.getDate(weeks: indexPath.row) {
            let startOfMonthComponents = dates.calendar.dateComponents([.month, .year], from: date)
            if let startOfMonth = dates.calendar.date(from: startOfMonthComponents) {
                let index = dates.getWeekIndex(date: startOfMonth)
                
                // render if row is 2 rows from start of month
                if indexPath.row == index + 2 {
                    cell.label.text = MonthOverlayView.monthNameFormmater.string(from: date)
                } else {
                    cell.label.text = ""
                }
            }
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return rowHeight
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dates?.numWeekRows ?? 0
    }
}
