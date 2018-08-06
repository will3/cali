//
//  Index.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class Index<Type, T> where T : Indexable, Type: Storable {
    var block: (Type) -> T
    
    var node: Node<IndexEntry<T>>?
    
    init(block: @escaping (Type) -> T) {
        self.block = block
    }
    
    func add(object: Type) {
        let v = block(object)
        let entry = IndexEntry(id: object.getID(), v: v)
        if let node = self.node {
            node.add(value: entry)
        } else {
            node = Node(value: entry)
        }
    }
}
