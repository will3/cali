//
//  Serialization.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

/// Implement this interface to deserialize through Deserializer
protocol Deserializable {
    init()
    func deserialize(json: [String: Any])
}

/// Deserializer
class Deserializer {
    /**
     * Given json array, deserializes objects
     *
     * - parameter jsonArray: JSON array
     * - returns: array of objects
     */
    static func deserializeArray<T>(jsonArray: [[String: Any]]?) -> [T]? where T : Deserializable {
        guard let jsonArray = jsonArray else { return nil }
        var objects: [T] = []
        for json in jsonArray {
            if let object : T = deserialize(json: json) {
                objects.append(object)
            }
        }
        return objects
    }
    
    /**
     * Given json, deserialize an object
     *
     * - parameter json: JSON
     * - returns: object
     */
    static func deserialize<T>(json: Any?) -> T? where T : Deserializable {
        guard let json = json as? [String: Any] else { return nil }
        
        let obj = T.init()
        obj.deserialize(json: json)
        
        return obj
    }
}
