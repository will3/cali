//
//  TableViews.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation
import UIKit

class TableViews {
	/// Register tableview cells
  static func register(tableview: UITableView, identifiers: [ String : AnyClass ]) {
      for kv in identifiers {
          tableview.register(kv.value, forCellReuseIdentifier: kv.key)
      }
  }
}
