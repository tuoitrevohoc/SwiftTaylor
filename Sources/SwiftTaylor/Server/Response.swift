//
//  HttpResponse.swift
//  SwiftifyServer
//
//  Created by Tran Thien Khiem on 14/6/18.
//

import Foundation
import NIO
import NIOHTTP1

public typealias ResponseStatus = HTTPResponseStatus

/// The response
public class Response {
    
    public let version: Version
    let handler: HTTPHandler
    let context: ChannelHandlerContext
    
    init(version: Version, handler: HTTPHandler, context: ChannelHandlerContext) {
        self.version = version
        self.handler = handler
        self.context = context
    }
    
    public func send(status: ResponseStatus, content data: Data) {
        let responseHead = HTTPResponseHead(version: version, status: status)
        context.writeAndFlush(handler.wrapOutboundOut(.head(responseHead)), promise: nil)
        
        var buffer = context.channel.allocator.buffer(capacity: data.count)
        buffer.write(bytes: [UInt8](data))
        context.writeAndFlush(handler.wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        context.writeAndFlush(handler.wrapOutboundOut(.end(nil)), promise: nil)
    }
}

public extension Response {
    
    /// Send a response as text and status
    ///
    /// - Parameters:
    ///   - status: the status
    ///   - content: the content
    func send(status: ResponseStatus, content: String) {
        if let data = content.data(using: .utf8) {
            send(status: status, content: data)
        }
    }
}
