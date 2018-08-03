//
//  CalendarView.swift
//  cali
//
//  Created by will3 on 3/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import UIKit

class CalendarView: UIView {
    let scrollView: UICollectionView
    
    override init(frame: CGRect) {
        let layout = UICollectionViewLayout()
        scrollView = UICollectionView(frame: frame, collectionViewLayout: layout)
        super.init(frame: frame)
        self.initialize()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        scrollView = UICollectionView()
        super.init(coder: aDecoder)
        self.initialize()
    }
    
    func initialize() {
        self.addSubview(scrollView)

        Layouts.list(self).addChild(
            Layouts.item(scrollView)
                .width(LayoutSize.MatchParent)
                .height(LayoutSize.MatchParent)
        ).install()
    }
}
