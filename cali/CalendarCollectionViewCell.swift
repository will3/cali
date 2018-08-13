//
//  CalendarCollectionViewCell.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit
import Layouts

/// Calendar collection view cell
class CalendarCollectionViewCell: UICollectionViewCell {
    enum Background {
        case white
        case grey
        case today
    }
    /// Identifier
    static let identifier = "CalendarCollectionViewCell"
    /// Label
    private let label = UILabel()
    /// Month label
    private let monthLabel = UILabel()
    /// View
    private let view = UIView()
    /// Circle view
    private let circleView = UIView()
    /// Left border
    private let leftBorder = UIView()
    /// Bottom border
    private let botBorder = UIView()
    /// Dot view
    private let dot = UIView()
    /// Weather icon view
    private let weatherIconView = WeatherIconView()
    /// Separator view
    private let separator = UIView()
    
    override var bounds: CGRect {
        didSet {
            layoutIfNeeded()
            updateCircle()
        }
    }
    
    /// Should show circle
    var shouldShowCircle: Bool = false { didSet {
        updateCircle()
        updateDot()
        weatherIconView.hasBackground = shouldShowCircle
        updateBackground()
        } }
    
    /// Background
    var background: Background = .white { didSet { updateBackground() } }
    /// Should draw left border
    var shouldDrawLeftBorder = false { didSet { updateLeftBorder() } }
    /// Should draw bottom border
    var shouldDrawBotBorder = false { didSet { updateBotBorder() } }
    /// Month
    var month: String = "" { didSet {
        updateLabels()
        updateDot() } }
    /// Day
    var day: String = "" { didSet { updateLabels() } }
    /// Weather icon
    var weatherIcon: String? { didSet { weatherIconView.icon = weatherIcon } }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        updateDotPosition()
    }

    /// Update left border
    func updateLeftBorder() {
        leftBorder.isHidden = !shouldDrawLeftBorder
    }
    
    /// Update bottom border
    func updateBotBorder() {
        botBorder.isHidden = !shouldDrawBotBorder
    }
    
    /// Number of events
    var numEvents = 0 {
        didSet { updateDot() }
    }
    
    /// Update circle
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
    
    /// Update background
    func updateBackground() {
        switch background {
        case .white:
            contentView.backgroundColor = Colors.white
        case .grey:
            contentView.backgroundColor = Colors.dimBackground
        case .today:
            if shouldShowCircle {
                contentView.backgroundColor = Colors.white
            } else {
                contentView.backgroundColor = Colors.lightAccent
            }
        }
    }
    
    /// Update labels
    func updateLabels() {
        monthLabel.text = month
        label.text = day
        layoutIfNeeded()
    }
    
    /// Update dot position
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
        
        leftBorder.backgroundColor = Colors.separator
        botBorder.backgroundColor = Colors.separator
        separator.backgroundColor = Colors.separator
        
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
        
        layout(separator)
            .parent(contentView)
            .pinBottom().pinLeft().pinRight()
            .height(1).install()
        
        layout(leftBorder)
            .parent(contentView)
            .pinLeft().pinTop().pinBottom()
            .width(2).install()
        
        layout(botBorder)
            .parent(contentView)
            .pinBottom().pinLeft().pinRight()
            .height(2).install()
        
        contentView.addSubview(dot)
    }
    
    /// Update dot
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
