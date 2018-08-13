//
//  DayPicker.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

protocol TimePickerDelegate : AnyObject {
    func timePickerDidFinish(_ timePicker: TimePicker)
    func timePickerDidChange(_ timePicker: TimePicker)
}

/// Timer picker
class TimePicker: UIView, DayViewDelegate {
    /// Delegate
    weak var delegate: TimePickerDelegate?
    
    /// Event
    var event : Event? { didSet {
        dayView.startDay = event?.startDay
        dayView.event = event
        updateEvent() } }

    /// View loaded
    private var loaded = false
    /// Bar
    private let bar = UIView()
    // Separator
    private let separator = UIView()
    /// Day view
    private let dayView = DayView()
    /// Title label
    private let titleLabel = UILabel()

    override func didMoveToSuperview() {
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    private func loadView() {
        backgroundColor = Colors.white
        
        dayView.delegate = self
        
        let rightButton = UIButton()
        rightButton.setImage(Images.tick, for: .normal)
        rightButton.addTarget(self, action: #selector(TimePicker.donePressed), for: .touchUpInside)
        
        titleLabel.textColor = Colors.accent
        titleLabel.font = Fonts.dayFont
        layout(titleLabel).center(bar).install()
        layout(rightButton)
            .parent(bar)
            .pinRight()
            .vertical(.center)
            .width(44)
            .height(44)
            .install()
        
        layout(self).stack([ layout(bar), layout(dayView) ]).install()
        layout(bar).height(44).install()
        
        separator.backgroundColor = Colors.separator
        layout(separator).parent(bar).pinLeft().pinRight().pinBottom().height(1).install()
        
        layer.cornerRadius = 8.0
        clipsToBounds = true
    }
    
    @objc private func donePressed() {
        delegate?.timePickerDidFinish(self)
    }
    
    private func updateEvent() {
        guard let event = self.event else { return }
        guard let startDay = event.startDay else { return }
        titleLabel.text = DateFormatters.EECommaDMMMFormatter.string(from: startDay)
    }
    
    // MARK: DayViewDelegate
    
    func dayViewDidChangeEvent(_ event: Event) {
        if event.id == self.event?.id {
            self.event = event
            // update event
            self.delegate?.timePickerDidChange(self)
        }
    }
}
