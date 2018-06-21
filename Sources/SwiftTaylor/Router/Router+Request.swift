//
//  Router+Request.swift
//  Sample
//
//  Created by Tran Thien Khiem on 21/6/18.
//

import Foundation

let ParameterKey = "parameters"

// MARK: - Add parameters to the request
public extension Request {
    
    /// get parameters
    public var parameters: [String: String] {
        return data[ParameterKey] as? [String: String] ?? [:]
    }
    
    /// get body as data
    ///
    /// - Returns: body as data
    public func getBody<Data: Decodable>() -> Data? {
        var result: Data? = nil
        let decoder = JSONDecoder()
        
        if let body = body,
            let parsedData = try? decoder.decode(Data.self, from: body) {
            result = parsedData
        }
        
        return result
    }
}
