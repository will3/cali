//
//  CreateEventTextInputCell.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit
import Layouts

class EventTitleCell: UITableViewCell, UITextFieldDelegate {
    static let identifier = "EventTitleCell"
    
    private let textField = UITextField()
    private let wrapper = UIView()
    
    var event: Event? { didSet { textField.text = event?.title ?? "" } }
    
    var placeholder = "" { didSet {
        textField.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [ NSAttributedStringKey.foregroundColor: Colors.primary ])
        } }
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        loadView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        loadView()
    }
    
    func focus() {
        textField.becomeFirstResponder()
    }
    
    func loadView() {
        textField.returnKeyType = .done
        textField.delegate = self
        textField.textColor = Colors.black
        textField.font = Fonts.fontNormal
        
        wrapper.addSubview(textField)
        contentView.addSubview(wrapper)
        
        layout(wrapper)
            .direction(.horizontal)
            .alignItems(.center)
            .stack([
                layout(textField)
                ])
            .install()
        
        layout(wrapper).matchParent().height(42).left(12).right(12).install()
 
        textField.placeholder = NSLocalizedString("Title", comment: "Create event title textfield placeholder")
        textField.tintColor = Colors.accent
        
        selectionStyle = .none
        
        textField.addTarget(self, action: #selector(EventTitleCell.textFieldChanged), for: .editingChanged)
    }

    @objc func textFieldChanged() {
        event?.title = textField.text ?? ""
    }
    
    // MARK: UITextFieldDelegate
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
