//
//  ServiceDelegate.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class ServiceDelegate : NSObject, NSXPCListenerDelegate {
    
    func listener(_ listener: NSXPCListener, shouldAcceptNewConnection newConnection: NSXPCConnection) -> Bool {
        newConnection.exportedInterface = NSXPCInterface(with: XPCFileReactorServiceProtocol.self)
        
        let exportedObject = XPCFileReactorService()
        newConnection.exportedObject = exportedObject
        newConnection.resume()
        
        return true
    }
    
}
