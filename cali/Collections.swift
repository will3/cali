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

protocol Indexable : Comparable, Codable { }

class Collection<T> where T: Storable {
    let name: String
    let storage = Storage.instance
    
    init(name: String) {
        self.name = name
    }
    
    func insert(object: T) {
        let data = try! JSONEncoder().encode(object)
        let id = object.getID()
        storage.insert(data: data, collection: name, id: id)
    }
    
    func update(object: T) {
        let data = try! JSONEncoder().encode(object)
        let id = object.getID()
        storage.update(data: data, collection: name, id: id)
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
