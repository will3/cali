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
    let prefix = "str"
    
    let userDefaults = UserDefaults.standard
    
    func insert(data: Data, collection: String, id: String) {
        let key = getKey(collection: collection, id: id)
        
        var keys = getKeys(collection: collection)
        keys.append(key)
        setKeys(collection: collection, keys: keys)
        
        write(data: data, key: key)
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
    
    private func getKey(collection: String, id: String) -> String {
        return "\(prefix)-\(collection)-\(id)"
    }
    
    private func getKeysKey(collection: String) -> String {
        return "\(prefix)-\(collection)$keys"
    }
    
    func write(data: Data, key: String) {
        userDefaults.set(data, forKey: key)
    }
    
}
