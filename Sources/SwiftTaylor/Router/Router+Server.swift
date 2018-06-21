//
//  Router+Server.swift
//  Sample
//
//  Created by Tran Thien Khiem on 21/6/18.
//

import Foundation

// MARK: - Extension on the server that adapt the router
public extension Server {
    
    /// Use the router as a middleware
    ///
    /// - Parameter router: the router
    public func use(router: Router) {
        use(handler: router.handle)
    }
}
