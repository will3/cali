//
//  CreateEventViewController.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class CreateEventViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, EventDateTimeCellDelegate {
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
                return EventTitleCell.identifier
            case .people:
                return EventPeopleCell.identifier
            case .allday:
                return EventToggleCell.identifier
            case .dateTime:
                return EventDateTimeCell.identifier
            case .location:
                return EventLocationCell.identifier
            case .alert:
                return EventDetailCell.identifier
            default:
                return EventToggleCell.identifier
            }
        }
    }
    
    let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    var sections: [[RowType]] = []
    private(set) var event: Event?
    
    func createEvent(start: Date, duration: TimeInterval) {
        event = EventService.instance.createEvent(start: start, duration: duration)
    }
    
    func editEvent(_ event: Event) {
        self.event = event
    }
    
    override func viewDidLoad() {
        view.addSubview(tableView)
        
        layout(tableView).matchParent().install()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        TableViews.register(tableview: tableView, identifiers: [
            EventToggleCell.identifier: EventToggleCell.self,
            EventTitleCell.identifier: EventTitleCell.self,
            EventPeopleCell.identifier: EventPeopleCell.self,
            EventDateTimeCell.identifier: EventDateTimeCell.self,
            EventDetailCell.identifier: EventDetailCell.self,
            EventLocationCell.identifier: EventLocationCell.self ])
        
        tableView.backgroundView = nil
        tableView.backgroundColor = Colors.dimBackground
        tableView.keyboardDismissMode = .interactive
        tableView.separatorColor = Colors.separator
        
        updateSections()
        
        navigationItem.title = NSLocalizedString("New Event", comment: "")
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: Images.cross, style: .plain, target: self, action: #selector(CreateEventViewController.crossPressed))
        let tickButton = UIBarButtonItem(image: Images.tick, style: .plain, target: self, action: #selector(CreateEventViewController.tickPressed))
        navigationItem.rightBarButtonItem = tickButton
        tickButton.tintColor = Colors.accent
    }
    
    @objc func crossPressed() {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Discard event", comment: ""), style: .destructive, handler: { (action) in
            
            if let event = self.event {
                EventService.instance.discardEvent(event)
            }
            
            self.dismiss(animated: true, completion: nil)
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func tickPressed() {
        // Create event
        dismiss(animated: true, completion: nil)
    }
    
    func updateSections() {
        sections = [
            [ .title ],
//            [ .people ],
//            [ .allday, .dateTime ],
            [ .dateTime ],
//            [ .location, .skypeCall ],
//            [ .desc ],
//            [ .alert, .isPrivate, .showAs ]
        ]
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = sections[indexPath.section][indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: rowType.cellIdentifier) else {
            return UITableViewCell()
        }
        
        switch rowType {
        case .title:
            guard let inputCell = cell as? EventTitleCell else { break }
            inputCell.event = event
        case .dateTime:
            guard let inputCell = cell as? EventDateTimeCell else { break }
            inputCell.event = event
            inputCell.delegate = self
        default:
            break
        }
        
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
    
    // MARK: EventDateTimeCellDelegate
    
    func eventDateTimeCellDidChange(_ view: EventDateTimeCell) {
        if let event = view.event {
            self.event = event
        }
    }
}
