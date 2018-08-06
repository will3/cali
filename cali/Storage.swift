//
//  UserDefaultsStorage.swift
//  cali
//
//  Created by will3 on 6/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

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
    
    func has(key: String) -> Bool {
        return userDefaults.object(forKey: key) != nil
    }
}
