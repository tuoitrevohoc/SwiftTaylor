//
//  HttpHandler.swift
//  SwiftifyServer
//
//  Created by Tran Thien Khiem on 14/6/18.
//

import Foundation
import NIO
import NIOHTTP1

/// The http handler
class HTTPHandler: ChannelInboundHandler {
    
    public typealias InboundIn = HTTPServerRequestPart
    public typealias OutboundOut = HTTPServerResponsePart
    
    private var request = Request()
    private var handler: ((Request, Response) -> Void)
    
    init(handler: @escaping (Request, Response) -> Void) {
        self.handler = handler
    }
    
    /// Channel read
    ///
    /// - Parameters:
    ///   - ctx: the context
    ///   - data: the data
    func channelRead(ctx: ChannelHandlerContext, data: NIOAny) {
        let requestPart = unwrapInboundIn(data)
        
        switch requestPart {
        case .head(let requestData):
            request.method = requestData.method
            request.headers = requestData.headers
            request.path = requestData.uri
            request.version = requestData.version
        case .body(let body):
            if body.readableBytes > 0,
                let bytes = body.getBytes(at: 0, length: body.readableBytes) {
                let data = Data(bytes: bytes)
                request.body = data
            }
        case .end:
            let response = Response(version: request.version, handler: self, context: ctx)
            handler(request, response)
        }
    }
}
