//
//  HttpResponse.swift
//  SwiftifyServer
//
//  Created by Tran Thien Khiem on 14/6/18.
//

import Foundation
import NIO
import NIOHTTP1

public struct HTTPResponse {
    public let version: HTTPVersion
    let handler: HTTPHandler
    let context: ChannelHandlerContext
    
    func send(status: HTTPResponseStatus, data: Data) {
        let responseHead = HTTPResponseHead(version: version, status: status)
        context.writeAndFlush(handler.wrapOutboundOut(.head(responseHead)), promise: nil)
        
        var buffer = context.channel.allocator.buffer(capacity: data.count)
        buffer.write(bytes: [UInt8](data))
        context.writeAndFlush(handler.wrapOutboundOut(.body(.byteBuffer(buffer))), promise: nil)
        context.writeAndFlush(handler.wrapOutboundOut(.end(nil)), promise: nil)
    }
}

public extension HTTPResponse {
    func send(status: HTTPResponseStatus, content: String) {
        if let data = content.data(using: .utf8) {
            send(status: status, data: data)
        }
    }
}
