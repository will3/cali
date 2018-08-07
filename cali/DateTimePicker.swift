//
//  FloatingDateTimeSelectionView.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

protocol DateTimePickerDelegate : AnyObject {
    func dateTimePickerDidFinish(_ dateTimePicker: DateTimePicker)
}

class DateTimePicker : UIView, UIScrollViewDelegate, DatePickerDelegate, TimePickerDelegate {
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    private var loaded = false
    
    weak var delegate : DateTimePickerDelegate?
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        if !loaded {
            loadView()
            loaded = true
        }
    }
    
    let datePicker = DatePicker()
    let scrollView = UIScrollView()
    let contentView = UIView()
    let pageControl = UIPageControl()
    let left = UIView()
    let right = UIView()
    let timePicker = TimePicker()
    
    var event: Event? { didSet {
        datePicker.event = event
        timePicker.event = event
        } }
    
    private func loadView() {
        let paddingHorizontal: Float = 4
        let paddingVertical: Float = 48
        datePicker.totalWidth = UIScreen.main.bounds.width - CGFloat(paddingHorizontal) - CGFloat(paddingHorizontal)
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurView = UIVisualEffectView(effect: blurEffect)
        layout(blurView).matchParent(self).install()
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(DateTimePicker.didTapBackground))
        blurView.addGestureRecognizer(tap)
        
        datePicker.delegate = self
        
        scrollView.showsHorizontalScrollIndicator = false
        layout(scrollView).matchParent(self).install()
        layout(contentView).matchParent(scrollView).install()
        layout(contentView)
            .width(.ratio(2))
            .height(.ratio(1))
            .install()
        scrollView.isPagingEnabled = true
        
        layout(contentView).stackHorizontal([
            left,
            right]).install()
        
        layout(left).width(.ratio(0.5)).install()
        layout(right).width(.ratio(0.5)).install()
        
        layout(datePicker)
            .parent(left)
            .horizontal(.stretch)
            .left(paddingHorizontal)
            .right(paddingHorizontal)
            .vertical(.center)
            .install()
        
        timePicker.delegate = self
        layout(timePicker)
            .matchParent(right)
            .insets(UIEdgeInsetsMake(
                CGFloat(paddingVertical),
                CGFloat(paddingHorizontal),
                CGFloat(paddingVertical),
                CGFloat(paddingHorizontal)))
            .install()
        
        pageControl.numberOfPages = 2
        pageControl.addTarget(self, action: #selector(DateTimePicker.didChangePage), for: .valueChanged)
        
        layout(pageControl)
            .parent(self)
            .pinLeft()
            .pinRight()
            .pinBottom()
            .height(60)
            .install()
        
        scrollView.delegate = self
    }
    
    @objc func didTapBackground() {
        dismiss()
    }
    
    @objc func didChangePage() {
        let contentOffset = CGPoint(x: CGFloat(pageControl.currentPage) * scrollView.bounds.width, y: 0)
        scrollView.setContentOffset(contentOffset, animated: true)
    }
    
    func dismiss() {
        self.removeFromSuperview()
    }
    
    // MARK: UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.size.width
        if page == floor(page) {
            pageControl.currentPage = Int(page)
        }
    }
    
    // MARK: DatePickerDelegate
    
    func datePickerDidChange(_ datePicker: DatePicker) {
        guard var event = self.event else { return }
        guard let selectedDate = datePicker.selectedDate else { return }
        event.changeDay(selectedDate)
        self.event = event
    }
    
    func datePickerDidFinish(_ datePicker: DatePicker) {
        dismiss()
        delegate?.dateTimePickerDidFinish(self)
    }
    
    // MARK: TimePickerDelegate
    
    func timePickerDidChange(_ timePicker: TimePicker) {
        self.event = timePicker.event
    }
    
    func timePickerDidFinish(_ timePicker: TimePicker) {
        dismiss()
        delegate?.dateTimePickerDidFinish(self)
    }
}
