//
//  HttpRequest.swift
//  SwiftifyServer
//
//  Created by Tran Thien Khiem on 14/6/18.
//

import Foundation
import NIOHTTP1

public typealias Version = HTTPVersion
public typealias Headers = HTTPHeaders
public typealias Method = HTTPMethod

/// The Request
public class Request {
    public var version = Version.init(major: 1, minor: 1)
    public var path = ""
    public var headers = Headers([])
    public var body: Data? = nil
    public var method: Method = .GET
    public var data = [String: Any]()
}

// MARK: - The method
extension Method {
    
    /// get http method as string
    public var stringValue: String {
        return "\(self)"
    }
}
