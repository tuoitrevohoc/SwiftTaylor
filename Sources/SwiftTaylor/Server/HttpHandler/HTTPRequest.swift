//
//  HttpRequest.swift
//  SwiftifyServer
//
//  Created by Tran Thien Khiem on 14/6/18.
//

import Foundation
import NIOHTTP1

public struct HTTPRequest {
    public var version = HTTPVersion.init(major: 1, minor: 1)
    public var path = ""
    public var headers = HTTPHeaders([])
    public var body: Data?
}
