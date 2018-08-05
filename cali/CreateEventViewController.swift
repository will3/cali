//
//  CreateEventViewController.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class CreateEventViewController : UIViewController, UITableViewDataSource, UITableViewDelegate {
    enum RowType {
        case title
        case people
        case allday
        case dateTime
        case location
        case skypeCall
        case desc
        case alert
        case isPrivate
        case showAs
        
        var cellIdentifier: String {
            switch self {
            case .title:
                return EventTextInputCell.identifier
            case .people:
                return EventPeopleCell.identifier
            case .allday:
                return EventToggleCell.identifier
            case .dateTime:
                return EventDateTimeCell.identifier
            case .location:
                return EventTextInputCell.identifier
            case .alert:
                return EventDetailCell.identifier
            default:
                return EventToggleCell.identifier
            }
        }
    }
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var sections: [[RowType]] = []
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        layout(tableView).matchParent().install()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        tableView.register(EventToggleCell.self, forCellReuseIdentifier: EventToggleCell.identifier)
        tableView.register(EventTextInputCell.self, forCellReuseIdentifier: EventTextInputCell.identifier)
        tableView.register(EventPeopleCell.self, forCellReuseIdentifier: EventPeopleCell.identifier)
        
        tableView.backgroundView = nil
        tableView.backgroundColor = Colors.dimBackground
        
        updateSections()
        
        navigationItem.title = NSLocalizedString("New Event", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Images.cross, style: .plain, target: self, action: #selector(CreateEventViewController.crossPressed))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Images.tick, style: .plain, target: self, action: #selector(CreateEventViewController.tickPressed))
    }
    
    @objc func crossPressed() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func tickPressed() {
        // Create event
        dismiss(animated: true, completion: nil)
    }
    
    func updateSections() {
        sections = [
            [ .title ],
            [ .people ],
            [ .allday, .dateTime ],
            [ .location, .skypeCall ],
            [ .desc ],
            [ .alert, .isPrivate, .showAs ]
        ]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = sections[indexPath.section][indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: rowType.cellIdentifier) else {
            return UITableViewCell()
        }
        
        // rowType.configure(cell: cell)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
}
