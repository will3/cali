//
//  Db.swift
//  cali
//
//  Created by will3 on 5/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

protocol Storable : Codable {
    func getID() -> String
}

class IndexEntry<T> : Comparable where T : Comparable {
    static func <(lhs: IndexEntry<T>, rhs: IndexEntry<T>) -> Bool {
        return lhs.v < rhs.v
    }
    
    static func ==(lhs: IndexEntry<T>, rhs: IndexEntry<T>) -> Bool {
        return lhs.v == rhs.v
    }
    
    let id: String
    let v: T
    
    init(id: String, v: T) {
        self.id = id
        self.v = v
    }
}

class Index<Type, T> where T : Comparable, Type: Storable {
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

class Node<T> where T : Comparable {
    var left: Node<T>?
    var right: Node<T>?
    let value: T
    
    init(value: T) {
        self.value = value
    }
    
    func add(value: T) {
        if value > self.value {
            if left == nil {
                left = Node(value: value)
            } else {
                left?.add(value: value)
            }
        } else {
            if right == nil {
                right = Node(value: value)
            } else {
                right?.add(value: value)
            }
        }
    }
    
    func appendValue(results: inout [T]) {
        results.append(value)
        left?.appendValue(results: &results)
        right?.appendValue(results: &results)
    }
    
    func search(less: T, results: inout [T]) {
        if value < less {
            results.append(value)
            left?.appendValue(results: &results)
        } else {
            right?.search(less: less, results: &results)
        }
    }
    
    func search(more: T, results: inout [T]) {
        if value > more {
            results.append(value)
            right?.appendValue(results: &results)
        } else {
            left?.search(more: more, results: &results)
        }
    }
    
    func search(min: T, max: T, results: inout [T]) {
        if value > min && value < max {
            results.append(value)
            left?.search(min: min, max: max, results: &results)
            right?.search(min: min, max: max, results: &results)
        } else if value <= min {
            right?.search(min: min, max: max, results: &results)
        } else if value >= max {
            left?.search(min: min, max: max, results: &results)
        }
    }
}

class Collection<T> where T: Storable {
    let name: String
    let storage = Storage.instance
    
    init(name: String) {
        self.name = name
    }
    
    func insert(object: T) {
        let data = try! JSONEncoder().encode(object)
        let id = object.getID()
        insert(data: data, id: id)
    }
    
    func insert(data: Data, id: String) {
        storage.insert(data: data, collection: name, id: id)
    }
    
    func find() -> [T] {
        let result = storage.find(collection: name)
        var objects: [T] = []
        for data in result {
            if let obj = try? JSONDecoder().decode(T.self, from: data) {
                objects.append(obj)
            }
        }
        return objects
    }
}

class Storage {
    static let instance = Storage()
    let prefix = "1337"
    
    let userDefaults = UserDefaults.standard
    
    func insert(data: Data, collection: String, id: String) {
        var keys = getKeys(collection: collection)
        keys.append(id)
        setKeys(collection: collection, keys: keys)
        
        write(data: data, key: id)
    }
    
    func findDocument(key: String) -> Data? {
        return userDefaults.data(forKey: key)
    }
    
    func find(collection: String) -> [Data] {
        let keys = getKeys(collection: collection)
        var result: [Data] = []
        for key in keys {
            if let document = findDocument(key: key) {
                result.append(document)
            }
        }
        return result
    }
    
    func setKeys(collection: String, keys: [ String ]) {
        let key = getKeysKey(collection: collection)
        userDefaults.set(keys, forKey: key)
    }
    
    func getKeys(collection: String) -> [ String ] {
        let key = getKeysKey(collection: collection)
        return userDefaults.array(forKey: key) as? [String] ?? [String]()
    }
    
    private func getKeysKey(collection: String) -> String {
        return "\(prefix)\(collection)$keys"
    }
    
    func write(data: Data, key: String) {
        userDefaults.set(data, forKey: key)
    }
    
}
