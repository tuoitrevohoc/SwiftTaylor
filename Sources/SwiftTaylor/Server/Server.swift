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
    
    /// port to listen on
    let port: Int
    
    typealias Next = () -> Void
    
    /// The handler
    var handler: ((HTTPRequest, HTTPResponse) -> Void)?
    
    /// Create a server with a port
    ///
    /// - Parameter port: port definition
    public init(port: Int) {
        self.port = port
    }
    
    public func use(handler: @escaping (HTTPRequest, HTTPResponse) -> Void) {
        self.handler = handler
    }
    
    func requestHandler(request: HTTPRequest, response: HTTPResponse) {
        handler?(request, response)
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
