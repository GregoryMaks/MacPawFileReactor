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
            
            var copyFileURL = fileURL
            var copyLimiter = 10
            
            while FileManager.default.fileExists(atPath: copyFileURL.path) && copyLimiter > 0 {
                copyFileURL = copyFileURL
                    .deletingPathExtension()
                    .deletingLastPathComponent()
                    .appendingPathComponent(copyFileURL.deletingPathExtension().lastPathComponent + " copy")
                    .appendingPathExtension(copyFileURL.pathExtension)
                copyLimiter -= 1
            }
            
            if !FileManager.default.fileExists(atPath: copyFileURL.path) {
                try FileManager.default.copyItem(atPath: path, toPath: copyFileURL.path)

                addSomeFun()
                result = true
            }
            else {
                result = false
            }
        }
        catch {
            result = false
        }
    }
    
}
