//
//  Server.swift
//  SwiftifyServer
//
//  Created by Tran Thien Khiem on 14/6/18.
//

import Foundation
import NIO
import NIOHTTP1

/// A Webserver
public class Server {
    
    public typealias Next = () -> Void
    public typealias MiddleWare = (Request, Response, Next) -> Void
    fileprivate typealias Handler = (Request, Response) -> Void
    
    /// port to listen on
    public let port: Int
    
    /// The handler
    fileprivate var handler: Handler = Server.defaultHandler
    
    /// Create a server with a port
    ///
    /// - Parameter port: port definition
    public init(port: Int) {
        self.port = port
    }
    
    public func use(handler: @escaping MiddleWare) {
        let oldHandler = self.handler
        
        self.handler = { request, response in
            handler(request, response, {
                oldHandler(request, response)
            })
        }
    }
    
    func requestHandler(request: Request, response: Response) {
        handler(request, response)
    }
    
    fileprivate static func defaultHandler(request: Request, response: Response) {
        response.send(status: .notFound, content: "Not Found")
    }
    
    /// start listening
    public func listen() throws {
        let group = MultiThreadedEventLoopGroup(numberOfThreads: System.coreCount)
        let bootstrap = ServerBootstrap(group: group)
            .serverChannelOption(ChannelOptions.backlog, value: 256)
            .serverChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR),
                                 value: 1)
            .childChannelInitializer({ channel in
                channel.pipeline.configureHTTPServerPipeline().then {
                    channel.pipeline.add(handler: HTTPHandler(handler: self.requestHandler))
                }
            })
            .childChannelOption(ChannelOptions.socket(IPPROTO_TCP, TCP_NODELAY), value: 1)
            .childChannelOption(ChannelOptions.socket(SocketOptionLevel(SOL_SOCKET), SO_REUSEADDR), value: 1)
            .childChannelOption(ChannelOptions.maxMessagesPerRead, value: 1)
            .childChannelOption(ChannelOptions.allowRemoteHalfClosure, value: true)
        
        defer {
            try! group.syncShutdownGracefully()
        }
        
        let channel = try bootstrap.bind(host: "::1", port: port).wait()
        
        guard let localAddress = channel.localAddress else {
            fatalError("Address is in used")
        }
        
        print("Server started and listening on \(localAddress)")
        
        try channel.closeFuture.wait()
    }
    
}
