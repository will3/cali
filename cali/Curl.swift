//
//  Curl.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

enum CurlError : Error {
    case string(String)
}

class Curl {
    static func get(url: URL, block: @escaping (CurlError?, [String: Any]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            guard let data = data, error == nil else {
                let err = CurlError.string(error?.localizedDescription ?? "No data")
                block(err, nil)
                return
            }
            
            let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
            if let responseJSON = responseJSON as? [String: Any] {
                block(nil, responseJSON)
                return
            }
        }
        
        task.resume()
    }
}
