//
//  EventListView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class EventListView: UIView, UITableViewDataSource, UITableViewDelegate {
    private var didLoad = false
    private var tableView: UITableView!
    var scrollView: UIScrollView {
        return tableView
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    override func didMoveToSuperview() {
        if !didLoad {
            loadView()
            didLoad = true
        }
    }
    
    func loadView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        addSubview(tableView)
        
        layout(tableView).matchParent().install()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}
