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

/// View controller to create event
class CreateEventViewController : UIViewController, UITableViewDataSource, UITableViewDelegate, EventDateTimeCellDelegate {

    private enum ViewType {
        case create
        case edit
    }
    
    /// Row type
    private enum RowType {
        case title
        case dateTime
        
        var cellIdentifier: String {
            switch self {
            case .title:
                return EventTitleCell.identifier
            case .dateTime:
                return EventDateTimeCell.identifier
            }
        }
    }
    
    /// Table view
    private let tableView = UITableView(frame: CGRect.zero, style: .grouped)
    /// Sections
    private var sections: [[RowType]] = []
    /// Event
    private(set) var event: Event?
    /// View type
    private var viewType = ViewType.create { didSet { updateViewType() } }
    /// Delete button
    private let deleteButton = DeleteEventButton()
    /// Event service
    private let eventSerivce = Injection.defaultContainer.eventService
    
    // MARK: Public

    /**
     * Create event
     * 
     * - param start: Start date
     * - duration: Duration
     */
    func createEvent(start: Date, duration: TimeInterval) {
        event = eventSerivce.createEvent(start: start, duration: duration)
        self.viewType = .create
    }
    
    /**
     * Edit event
     * 
     * - param event: Event
     */
    func editEvent(_ event: Event) {
        self.event = event
        self.viewType = .edit
    }
    
    // MARK: UIViewController

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
        
        updateNavigationItemTitle()
        
        let tickButton = UIBarButtonItem(image: Images.tick, style: .plain, target: self, action: #selector(CreateEventViewController.tickPressed))
        navigationItem.rightBarButtonItem = tickButton
        tickButton.tintColor = Colors.accent
        tickButton.accessibilityIdentifier = AccessibilityIdentifier.tickButton.rawValue
        
        layout(deleteButton).parent(view).pinBottom(20).horizontal(.center).install()
        deleteButton.button.addTarget(self, action: #selector(CreateEventViewController.deletePressed), for: .touchUpInside)
        
        updateLeftBarButtons()
        
        AccessibilityIdentifier.createEventView.set(viewController: self)        
    }
    
    private func updateNavigationItemTitle() {
        switch viewType {
        case .create:
            navigationItem.title = NSLocalizedString("New Event", comment: "")
        case .edit:
            navigationItem.title = NSLocalizedString("Edit Event", comment: "")
        }
    }
    
    // MARK: UITableViewDataSource

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
        }
        
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }

    // MARK: UITableViewDelegate

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
    
    // MARK: EventDateTimeCellDelegate
    
    func eventDateTimeCellDidChange(_ view: EventDateTimeCell) {
        if let event = view.event {
            self.event = event
        }
    }

    // MARK: Private

    @objc private func crossPressed() {
        confirmDeleteEvent(word: NSLocalizedString("Discard Event", comment: ""))
    }
    
    @objc private func tickPressed() {
        self.backOrDismiss()
    }
    
    private func updateSections() {
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
    
    private func updateViewType() {
        switch viewType {
        case .create:
            deleteButton.isHidden = true
        case .edit:
            deleteButton.isHidden = false
        }
        
        updateNavigationItemTitle()
        updateLeftBarButtons()
    }
    
    private func updateLeftBarButtons() {
        switch viewType {
        case .create:
            let crossButton = UIBarButtonItem(image: Images.cross, style: .plain, target: self, action: #selector(CreateEventViewController.crossPressed))
            navigationItem.leftBarButtonItem = crossButton
            crossButton.accessibilityIdentifier = AccessibilityIdentifier.crossButton.rawValue
        case .edit:
            navigationItem.leftBarButtonItem = nil
        }
    }
    
    @objc private func deletePressed() {
        confirmDeleteEvent(word: NSLocalizedString("Delete Event", comment: ""))
    }
    
    private func confirmDeleteEvent(word: String) {
        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: word, style: .destructive, handler: { (action) in
            
            if let event = self.event {
                self.eventSerivce.discardEvent(event)
            }
            
            self.backOrDismiss()
        }))
        
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: ""), style: .cancel, handler: nil))
        
        present(alertController, animated: true, completion: nil)
    }
    
    private func backOrDismiss() {
        if self.presentingViewController != nil {
            self.dismiss(animated: true, completion: nil)
        } else {
            self.navigationController?.popViewController(animated: true)
        }
    }
}
