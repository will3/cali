//
//  IndexEntry.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class IndexEntry<T> : Indexable where T : Indexable {
    let id: String
    let v: T
    
    static func <(lhs: IndexEntry<T>, rhs: IndexEntry<T>) -> Bool {
        return lhs.v < rhs.v
    }
    
    static func ==(lhs: IndexEntry<T>, rhs: IndexEntry<T>) -> Bool {
        return lhs.v == rhs.v
    }
    
    init(id: String, v: T) {
        self.id = id
        self.v = v
    }
}
