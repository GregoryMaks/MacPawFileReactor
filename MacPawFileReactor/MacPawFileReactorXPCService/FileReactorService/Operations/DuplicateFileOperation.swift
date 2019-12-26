//
//  DuplicateFileOperation.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/26/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class DuplicateFileOperation: BaseReactorOperation {
    
    private (set) var result: Bool = false
    
    override func main() {
        do {
            let fileURL = URL(fileURLWithPath: path)
            let copyFilePath = fileURL.deletingPathExtension().path + " copy" + "." + fileURL.pathExtension
            
            if (!FileManager.default.fileExists(atPath: copyFilePath)) {
                try FileManager.default.copyItem(atPath: path, toPath: copyFilePath)
                addSomeFun()
                
                result = true
            }
        }
        catch {
            result = false
        }
    }
    
}
