//
//  BaseReactorOperation.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/26/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class BaseReactorOperation: Operation {
    
    public let path: String
    
    public required init(path: String) {
        self.path = path
    }
    
    public func addSomeFun() {
        // Adding some random delay to simulate long running process (for better fun experience)
        Thread.sleep(forTimeInterval: Double.random(in: 0.0...2.0))
    }
    
}
