//
//  RemoveFileOperation.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class RemoveFileOperation: BaseReactorOperation {
    
    private (set) var result: Bool = false
    
    override func main() {
        do {
            try FileManager.default.removeItem(atPath: path)
            addSomeFun()
            
            result = true
        }
        catch {
            result = false
        }
    }
    
}
