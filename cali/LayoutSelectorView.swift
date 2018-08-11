//
//  LayoutSelectorView.swift
//  cali
//
//  Created by will3 on 9/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

protocol LayoutSelectorViewDelegate : AnyObject {
    func layoutSelectorViewDidChange(_ view: LayoutSelectorView)
}

/// Layout selector view
class LayoutSelectorView : UIView, UITableViewDataSource, UITableViewDelegate {
    enum LayoutType {
        case agenda
        case day
    }

    weak var delegate : LayoutSelectorViewDelegate?

    private var didLoad = false
    private let tableView = UITableView()
    private let rows : [LayoutType] = [.agenda, .day]
    var selectedType = LayoutType.agenda

    let preferredRowHeight : Float = 50
    var preferredHeight : Float {
        return preferredRowHeight * 2
    }
    
    override func didMoveToSuperview() {
        super.didMoveToSuperview()
        
        if superview != nil {
            if !didLoad {
                loadView()
                didLoad = true
            }
        }
    }
    
    func loadView() {
        tableView.register(LayoutSelectorCell.self, forCellReuseIdentifier: LayoutSelectorCell.identifier)
        
        tableView.isScrollEnabled = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.separatorStyle = .none
        
        layout(tableView)
            .height(preferredHeight)
            .matchParent(self)
            .install()
        
        
        backgroundColor = UIColor.white
    }
    
    // UITableViewDataSource
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: LayoutSelectorCell.identifier) as? LayoutSelectorCell else {
            return UITableViewCell()
        }
        
        let rowType = rows[indexPath.row]
        
        switch rowType {
        case .agenda:
            cell.iconView.image = Images.agenda
            cell.label.text = NSLocalizedString("Agenda", comment: "")
        case .day:
            cell.iconView.image = Images.day
            cell.label.text = NSLocalizedString("Day", comment: "")
        }
        
        return cell
    }
    
    // UITableViewDelegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(preferredRowHeight)
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        selectedType = rows[indexPath.row]
        delegate?.layoutSelectorViewDidChange(self)
    }
    
    class LayoutSelectorCell : UITableViewCell {
        static let identifier = "LayoutSelectorCell"
        
        var didLoad = false
        let iconView = UIImageView()
        let label = UILabel()
        let separator = UIView()
        
        var showSeparator = false {
            didSet {
                updateSeparator()
            }
        }
        
        override func didMoveToSuperview() {
            super.didMoveToSuperview()
            
            if superview != nil {
                if !didLoad {
                    loadView()
                    didLoad = true
                }
            }
        }
        
        func loadView() {
            backgroundColor = Colors.white
            
            layout(contentView)
                .translatesAutoresizingMaskIntoConstraints()
                .alignItems(.center)
                .stackHorizontal([
                    layout(iconView).width(20).height(20).left(18),
                    layout(label).left(18)
                ]).install()
            
            separator.backgroundColor = Colors.separator
            layout(separator).pinLeft().pinRight().pinBottom().height(1).install()
            updateSeparator()
        }
        
        private func updateSeparator() {
            separator.isHidden = !showSeparator
        }
    }
}
