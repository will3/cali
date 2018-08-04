//
//  CalendarCollectionViewCell.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class CalendarCollectionViewCell: UICollectionViewCell {
    static let identifier = "CalendarCollectionViewCell"
    private(set) var label: UILabel?
    private(set) var monthLabel: UILabel?
    private(set) var view: UIView?
    private(set) var circleView: UIView?
    
    override var bounds: CGRect {
        didSet {
            layoutIfNeeded()
            updateCircle()
        }
    }
    
    var shouldShowCircle: Bool = false { didSet { updateCircle() } }
    
    var isPast: Bool = false { didSet { updateIsPast() } }
    
    func updateCircle() {
        guard let circleView = self.circleView else { return }
        if shouldShowCircle {
            circleView.backgroundColor = Colors.accent
            circleView.superview?.layoutIfNeeded()
            circleView.layer.cornerRadius = circleView.bounds.size.height / 2.0
            circleView.clipsToBounds = true
            label?.textColor = Colors.white
            monthLabel?.textColor = Colors.white
        } else {
            circleView.backgroundColor = UIColor.clear
            label?.textColor = Colors.primary
            monthLabel?.textColor = Colors.primary
        }
    }
    
    func updateIsPast() {
        if isPast {
            contentView.backgroundColor = Colors.dimBackground
        } else {
            contentView.backgroundColor = UIColor.clear
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        let circleView = UIView()
        contentView.addSubview(circleView)
        
        let view = UIView()
        
        let label = UILabel(frame: contentView.bounds)
        label.font = Fonts.dayFont;
        label.textAlignment = .center
        label.textColor = Colors.primary
        view.addSubview(label)
        
        let monthLabel = UILabel()
        monthLabel.textAlignment = .center
        monthLabel.font = Fonts.monthFont;
        monthLabel.textColor = Colors.primary
        view.addSubview(monthLabel)
        contentView.addSubview(view)
        
        let botBorder = UIView()
        botBorder.backgroundColor = Colors.separator
        contentView.addSubview(botBorder)
        
        layout(botBorder)
            .horizontal(.Stretch)
            .vertical(.Trailing)
            .height(1.0)
            .install()
        
        layoutStack(view)
            .children([
                layout(monthLabel),
                layout(label)
                ])
            .install()
        
        layout(view).center().install()
        
        layout(circleView)
            .horizontal(.Stretch)
            .vertical(.Center)
            .aspect(1)
            .insets(UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0))
            .install()
        
        self.label = label
        self.monthLabel = monthLabel
        self.view = view
        self.circleView = circleView
        
        updateCircle()
        updateIsPast()
    }
}
