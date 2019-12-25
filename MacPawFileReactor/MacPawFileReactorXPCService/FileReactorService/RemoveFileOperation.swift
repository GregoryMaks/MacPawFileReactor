//
//  RemoveFileOperation.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class RemoveFileOperation: Operation {
    
    public let path: String
    private (set) var result: Bool = false
    
    public init(path: String) {
        self.path = path
    }
    
    override func main() {
        do {
            try FileManager.default.removeItem(atPath: path)
            result = true
        }
        catch {
            result = false
        }
    }
    
}
