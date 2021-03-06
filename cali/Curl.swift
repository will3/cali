//
//  Curl.swift
//  cali
//
//  Created by will3 on 10/08/18.
//  Copyright © 2018 will3. All rights reserved.
//

import Foundation

enum ServiceError : Error {
    case curlError(CurlError)
    case badData
}

enum CurlError : Error {
    case string(String)
}

/// Curl utility
class Curl {
    /**
     * Get request
     * 
     * - param url: URL
     * - param block: Return block
     */
    static func get(url: URL, block: @escaping (CurlError?, [String: Any]?) -> Void) {
        let task = URLSession.shared.dataTask(with: url) {
            data, response, error in
            
            DispatchQueue.main.async {
                guard let data = data, error == nil else {
                    let err = CurlError.string(error?.localizedDescription ?? "No data")
                    block(err, nil)
                    return
                }
                
                let responseJSON = try? JSONSerialization.jsonObject(with: data, options: [])
                if let responseJSON = responseJSON as? [String: Any] {
                    block(nil, responseJSON)
                } else {
                    block(nil, nil)
                }
            }
        }
        
        task.resume()
    }
}
