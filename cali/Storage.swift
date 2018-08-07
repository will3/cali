//
//  UserDefaultsStorage.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

protocol StorageChannel {
    func write(data: Any, key: String)
    func has(key: String) -> Bool
    func read(key: String) -> Any?
}

class UserDefaultStorage : StorageChannel {
    let userDefaults = UserDefaults.standard
    func write(data: Any, key: String) {
        userDefaults.set(data, forKey: key)
    }
    
    func has(key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
    
    func read(key: String) -> Any? {
        return userDefaults.object(forKey: key)
    }
}

class Storage {
    static let instance = Storage()
    let prefix = "1337"
    
    var channel = UserDefaultStorage()

    func insert(data: Data, collection: String, id: String) {
        var keys = getKeys(collection: collection)
        keys.append(id)
        setKeys(collection: collection, keys: keys)
        
        write(data: data, key: id)
    }
    
    func update(data: Data, collection: String, id: String) {
        let keys = getKeys(collection: collection)
        if !keys.contains(id) {
            return
        }
        write(data: data, key: id)
    }
    
    
    
    func findDocument(key: String) -> Data? {
        return channel.read(key: key) as? Data
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
    
    func write(data: Data, key: String) {
        channel.write(data: data, key: key)
    }
    
    func has(key: String) -> Bool {
        return channel.has(key: key)
    }
    
    private func setKeys(collection: String, keys: [ String ]) {
        let key = getKeysKey(collection: collection)
        channel.write(data: keys, key: key)
    }
    
    private func getKeys(collection: String) -> [ String ] {
        let key = getKeysKey(collection: collection)
        return channel.read(key: key) as? [String] ?? [String]()
    }
    
    private func getKeysKey(collection: String) -> String {
        return "\(prefix)\(collection)$keys"
    }
}
