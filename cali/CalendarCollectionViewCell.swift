//
//  CalendarCollectionViewCell.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit
import Layouts

class CalendarCollectionViewCell: UICollectionViewCell {
    enum Background {
        case white
        case grey
        case today
    }
    static let identifier = "CalendarCollectionViewCell"
    private let label = UILabel()
    private let monthLabel = UILabel()
    private let view = UIView()
    private let circleView = UIView()
    private let leftBorder = UIView()
    private let botBorder = UIView()
    private let dot = UIView()
    private let weatherIconView = WeatherIconView()
    
    override var bounds: CGRect {
        didSet {
            layoutIfNeeded()
            updateCircle()
        }
    }
    
    var shouldShowCircle: Bool = false { didSet {
        updateCircle()
        updateDot()
        weatherIconView.hasBackground = shouldShowCircle
        } }
    var background: Background = .white { didSet { updateBackground() } }
    var drawLeftBorder = false { didSet { updateLeftBorder() } }
    var drawBotBorder = false { didSet { updateBotBorder() }}
    var month: String = "" { didSet {
        updateLabels()
        updateDot() } }
    var day: String = "" { didSet { updateLabels() } }
    var weatherIcon: String? { didSet { weatherIconView.icon = weatherIcon } }
    
    func updateLeftBorder() {
        leftBorder.isHidden = !drawLeftBorder
    }
    
    func updateBotBorder() {
        botBorder.isHidden = drawBotBorder
    }
    
    func updateCircle() {
        if shouldShowCircle {
            circleView.backgroundColor = Colors.accent
            circleView.superview?.layoutIfNeeded()
            circleView.layer.cornerRadius = circleView.bounds.size.height / 2.0
            circleView.clipsToBounds = true
            label.textColor = Colors.white
            monthLabel.textColor = Colors.white
        } else {
            circleView.backgroundColor = UIColor.clear
            label.textColor = Colors.primary
            monthLabel.textColor = Colors.primary
        }
    }
    
    func updateBackground() {
        switch background {
        case .white:
            contentView.backgroundColor = Colors.white
        case .grey:
            contentView.backgroundColor = Colors.dimBackground
        case .today:
            contentView.backgroundColor = Colors.lightAccent
        }
    }
    
    func updateLabels() {
        monthLabel.text = month
        label.text = day
        layoutIfNeeded()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateDotPosition()
    }
    
    private func updateDotPosition() {
        let dotWidth : CGFloat = CGFloat(3)
        let labelEndY = view.bounds.height + view.frame.origin.y
        let height = contentView.bounds.height
        
        dot.frame = CGRect(
            x: (contentView.bounds.width - CGFloat(dotWidth)) / CGFloat(2.0),
            y: labelEndY + (height - labelEndY - dotWidth) / 2.0 - 3.0,
            width: dotWidth,
            height: dotWidth
        )
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        contentView.addSubview(circleView)
        
        label.font = Fonts.dayFont;
        label.textAlignment = .center
        label.textColor = Colors.primary
        view.addSubview(label)
        
        monthLabel.textAlignment = .center
        monthLabel.font = Fonts.calendarSmallLight;
        monthLabel.textColor = Colors.primary
        view.addSubview(monthLabel)
        contentView.addSubview(view)
        
        botBorder.backgroundColor = Colors.separator
        contentView.addSubview(botBorder)
        
        layout(view)
            .alignItems(.center)
            .stack([
                layout(monthLabel),
                layout(label)
                ])
            .install()
        
        layout(view).center().install()
        
        layout(circleView)
            .horizontal(.stretch)
            .left(4)
            .right(4)
            .vertical(.center)
            .aspect(1)
            .install()
        
        updateCircle()
        updateBackground()
        updateDot()
        
        layout(weatherIconView)
            .parent(contentView)
            .width(20)
            .height(20)
            .pinRight(2)
            .pinBottom(2)
            .install()
        
        layout(botBorder)
            .horizontal(.stretch)
            .vertical(.trailing)
            .height(1.0)
            .install()
        
        contentView.addSubview(dot)
    }
    
    var numEvents = 0 {
        didSet { updateDot() }
    }
    
    private func updateDot() {
        let shouldShowDot = month.isEmpty && !shouldShowCircle
        if shouldShowDot {
            if numEvents == 1 {
                dot.backgroundColor = Colors.dotColorOne
            } else if numEvents == 2 {
                dot.backgroundColor = Colors.dotColorTwo
            } else if numEvents >= 3 {
                dot.backgroundColor = Colors.dotColorThree
            } else {
                dot.backgroundColor = UIColor.clear
            }
        } else {
            dot.backgroundColor = UIColor.clear
        }
    }
}
