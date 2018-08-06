//
//  Node.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

class Node<T> : Codable where T : Indexable {
    var left: String?
    var right: String?
    let value: T
    let id : String
    
    init(value: T, id: String? = nil) {
        self.value = value
        self.id = id ?? NSUUID().uuidString
        self.save()
    }
    
    func save() {
        if let data = try? JSONEncoder().encode(self) {
            Storage.instance.write(data: data, key: id)
        }
    }
    
    static func load(id: String) -> Node<T>? {
        if let data = Storage.instance.findDocument(key: id) {
            if let node = try? JSONDecoder().decode(Node<T>.self, from: data) {
                return node
            }
        }
        return nil
    }
    
    static func has(id: String) -> Bool {
        return Storage.instance.has(key: id)
    }
    
    func add(value: T) {
        if value < self.value {
            if let _ = self.left {
                leftNode?.add(value: value)
            } else {
                left = Node(value: value).id
            }
        } else {
            if let _ = self.right {
                rightNode?.add(value: value)
            } else {
                right = Node(value: value).id
            }
        }
    }
    
    func appendValue(results: inout [T]) {
        results.append(value)
        
        leftNode?.appendValue(results: &results)
        rightNode?.appendValue(results: &results)
    }
    
    var leftNode: Node<T>? {
        if let left = self.left {
            return Node.load(id: left)
        }
        return nil
    }
    
    var rightNode: Node<T>? {
        if let right = self.right {
            return Node.load(id: right)
        }
        return nil
    }
    
    func search(less: T, results: inout [T]) {
        if value < less {
            results.append(value)
            leftNode?.appendValue(results: &results)
        }
        
        rightNode?.search(less: less, results: &results)
    }
    
    func search(more: T, results: inout [T]) {
        if value > more {
            results.append(value)
            rightNode?.appendValue(results: &results)
        }
        
        leftNode?.search(more: more, results: &results)
    }
    
    func search(equal: T, results: inout [T]) {
        if value == equal {
            results.append(equal)
        }
        
        rightNode?.search(equal: equal, results: &results)
    }
    
    func search(min: T, max: T, results: inout [T]) {
        if value > min && value < max {
            results.append(value)
            leftNode?.search(min: min, max: max, results: &results)
            rightNode?.search(min: min, max: max, results: &results)
        } else if value <= min {
            rightNode?.search(min: min, max: max, results: &results)
        } else if value >= max {
            leftNode?.search(min: min, max: max, results: &results)
        }
    }
}
