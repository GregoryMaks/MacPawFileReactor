//
//  FileReactorService.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class XPCFileReactorService: XPCFileReactorServiceProtocol {
    
    private let operationQueue = OperationQueue()
    
    public func removeFiles(atPaths paths: [String], withReply reply: @escaping ([Bool]) -> Void) {
        let operations = paths.map(RemoveFileOperation.init)
        operationQueue.isSuspended = true
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        let barrier = BlockOperation {
            reply(operations.map { $0.result })
        }
        operations.forEach(barrier.addDependency)
        operationQueue.addOperation(barrier)
        operationQueue.isSuspended = false
    }
    
    public func duplicateFiles(atPaths paths: [String], withReply reply: @escaping ([Bool]) -> Void) {
        // TODO
    }
    
    public func countHashSumOfFiles(atPaths paths: [String], withReply reply: @escaping () -> Void) {
        // TODO
    }
    
}
