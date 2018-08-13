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
class CreateEventViewController : UIViewController {
    /// Type of view controler
    private enum ViewType {
        /// Creating an event
        case create
        /// Editing an event
        case edit
    }
    
    /// Row type
    private enum RowType {
        case title
        case dateTime
        case planForWeather
        
        var cellIdentifier: String {
            switch self {
            case .title:
                return EventTitleCell.identifier
            case .dateTime:
                return EventDateTimeCell.identifier
            case .planForWeather:
                return EventToggleCell.identifier
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
    /// Event title cell
    var eventTitleCell : EventTitleCell?
    /// Keyboard frame
    var keyboardFrame: CGRect?
    
    // MARK: - Public

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
    
    // MARK: - UIViewController

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
        tickButton.accessibilityIdentifier = AccessibilityIdentifier.tickButton
        
        layout(deleteButton).parent(view).pinBottom(20).horizontal(.center).install()
        deleteButton.button.addTarget(self, action: #selector(CreateEventViewController.deletePressed), for: .touchUpInside)
        
        updateLeftBarButtons()
        
        AccessibilityIdentifier.set(viewController: self, identifier: AccessibilityIdentifier.createEventView)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventViewController.keyboardWillShow), name: .UIKeyboardWillShow, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventViewController.keyboardWillHide), name: .UIKeyboardWillHide, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(CreateEventViewController.keyboardWillChangeFrame(notification:)), name: .UIKeyboardWillChangeFrame, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func keyboardWillShow() {
        updateTableViewInsets()
    }
    
    @objc func keyboardWillHide() {
        updateTableViewInsets()
    }
    
    /// Update talbe view insets
    private func updateTableViewInsets() {
        let inset = UIEdgeInsets(top: 0, left: 0, bottom: keyboardFrame?.size.height ?? 0, right: 0)
        tableView.contentInset = inset
        tableView.scrollIndicatorInsets = inset
    }
    
    @objc func keyboardWillChangeFrame(notification: NSNotification) {
        keyboardFrame = (notification.userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue).cgRectValue
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        if viewType == .create {
            self.eventTitleCell?.focus()
        }
    }
    
    private func updateNavigationItemTitle() {
        switch viewType {
        case .create:
            navigationItem.title = NSLocalizedString("New Event", comment: "")
        case .edit:
            navigationItem.title = NSLocalizedString("Edit Event", comment: "")
        }
    }

    // MARK: - Private

    @objc private func crossPressed() {
        confirmDeleteEvent(word: NSLocalizedString("Discard Event", comment: ""))
    }
    
    @objc private func tickPressed() {
        self.backOrDismiss()
    }
    
    private func updateSections() {
        sections = [
            [ .title ],
            [ .dateTime ],
            [ .planForWeather ]
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
            crossButton.accessibilityIdentifier = AccessibilityIdentifier.crossButton
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

extension CreateEventViewController : UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let rowType = sections[indexPath.section][indexPath.row]
        guard let cell = tableView.dequeueReusableCell(withIdentifier: rowType.cellIdentifier) else {
            return UITableViewCell()
        }
        
        guard let event = self.event else { return UITableViewCell() }
        
        switch rowType {
        case .title:
            guard let titleCell = cell as? EventTitleCell else { break }
            self.eventTitleCell = titleCell
            titleCell.event = event
        case .dateTime:
            guard let dateTimeCell = cell as? EventDateTimeCell else { break }
            dateTimeCell.event = event
            dateTimeCell.delegate = self
        case .planForWeather:
            guard let toggleCell = cell as? EventToggleCell else { break }
            toggleCell.titleLabel.text = NSLocalizedString("Plan for weather", comment: "")
            toggleCell.toggle.setOn(event.planForWeather, animated: false)
            toggleCell.toggle.addTarget(self, action: #selector(CreateEventViewController.planForWeatherChanged(sender:)), for: .valueChanged)
        }
        
        return cell
    }
    
    @objc func planForWeatherChanged(sender: UISwitch) {
        guard let event = self.event else { return }
        event.planForWeather = !event.planForWeather
        try? event.managedObjectContext?.save()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sections[section].count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}

extension CreateEventViewController : EventDateTimeCellDelegate {
    func eventDateTimeCellDidChange(_ view: EventDateTimeCell) {
        if let event = view.event {
            self.event = event
        }
    }
}
