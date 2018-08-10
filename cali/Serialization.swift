//
//  Serialization.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

protocol IDeserializable {
    init()
    func deserialize(json: [String: Any])
}

class Deserializer {
    static func deserializeArray<T>(jsonArray: [[String: Any]]?) -> [T]? where T : IDeserializable {
        guard let jsonArray = jsonArray else { return nil }
        var objects: [T] = []
        for json in jsonArray {
            let object : T = deserialize(json: json)
            objects.append(object)
        }
        return objects
    }
    
    static func deserialize<T>(json: [String: Any]) -> T where T : IDeserializable {
        let obj = T.init()
        obj.deserialize(json: json)
        return obj
    }
    
    static func deserialize<T>(json: [String: Any]?) -> T? where T : IDeserializable {
        guard let json = json else { return nil }
        return deserialize(json: json)
    }
    
    static func deserialize<T>(json: Any?) -> T? where T : IDeserializable {
        guard let json = json as? [String: Any] else { return nil }
        return deserialize(json: json)
    }
}
