//
//  FloatingDateTimeSelectionView.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class DateTimeSelectionView : UIView, CalendarViewDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private var loaded = false
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    let dateSelectionView = DateSelectionView()
    
    var event: Event? { didSet {
        dateSelectionView.event = event } }
    
    private func loadView() {
        let paddingHorizontal: Float = 4
        dateSelectionView.totalWidth = UIScreen.main.bounds.width - CGFloat(paddingHorizontal) - CGFloat(paddingHorizontal)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        layout(blurView).matchParent(self).install()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DateTimeSelectionView.didTapBackground))
        blurView.addGestureRecognizer(tap)
        
        layout(dateSelectionView)
            .parent(self)
            .horizontal(.stretch)
            .left(paddingHorizontal)
            .right(paddingHorizontal)
            .vertical(.center)
            .install()
        
        dateSelectionView.delegate = self
    }
    
    @objc func didTapBackground() {
        self.removeFromSuperview()
    }
    
    // MARK: CalendarViewDelegate
    
    func calendarViewDidChangeSelectedDate(_ calendarView: CalendarView) {
        guard var event = self.event else { return }
        guard let selectedDate = calendarView.selectedDate else { return }
        
        event.changeDay(selectedDate)
        
        self.event = event
    }
}
