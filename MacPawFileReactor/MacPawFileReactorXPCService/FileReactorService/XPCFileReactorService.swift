//
//  FileReactorService.swift
//  MacPawFileReactorXPCService
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class XPCFileReactorService: XPCFileReactorServiceProtocol {
    
    private weak var connection: NSXPCConnection?
    private let operationQueue = OperationQueue()
    
    init(connection: NSXPCConnection) {
        self.connection = connection
    }
    
    func removeFiles(atPaths paths: [String], withReply reply: @escaping ([Bool]) -> Void) {
        guard let connection = connection,
              let eventingService = connection.remoteObjectProxy as? XPCFileReactorServiceEventingProtocol
        else {
            reply([Bool](repeating: false, count: paths.count))
            return
        }
        
        let totalOperations = UInt(paths.count)
        var completedOperations = UInt(0)
        
        let operations = paths.map(RemoveFileOperation.init)
        operations.forEach { op in
            op.completionBlock = {
                completedOperations += 1
                eventingService.notify(operationsCompleted: completedOperations, from: totalOperations)
            }
        }
        
        operationQueue.isSuspended = true
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        let barrier = BlockOperation {
            reply(operations.map { $0.result })
        }
        operations.forEach(barrier.addDependency)
        operationQueue.addOperation(barrier)
        operationQueue.isSuspended = false
    }
    
    func duplicateFiles(atPaths paths: [String], withReply reply: @escaping ([Bool]) -> Void) {
        // TODO
    }
    
    func countHashSumOfFiles(atPaths paths: [String], withReply reply: @escaping () -> Void) {
        // TODO
    }
    
}
