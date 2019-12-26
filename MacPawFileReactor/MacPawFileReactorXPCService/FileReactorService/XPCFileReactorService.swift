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
        perform(operation: RemoveFileOperation.self, withFilesAtPaths: paths) { operations in
            guard let operations = operations else {
                reply([])
                return
            }
            
            reply(operations.map { $0.result })
        }
    }
    
    func duplicateFiles(atPaths paths: [String], withReply reply: @escaping ([Bool]) -> Void) {
        perform(operation: DuplicateFileOperation.self, withFilesAtPaths: paths) { operations in
            guard let operations = operations else {
                reply([Bool](repeating: false, count: paths.count))
                return
            }
            
            reply(operations.map { $0.result })
        }
    }
    
    func countHashSumOfFiles(atPaths paths: [String], withReply reply: @escaping ([Data]) -> Void) {
        perform(operation: CountHashOfFileOperation.self, withFilesAtPaths: paths) { operations in
            guard let operations = operations else {
                reply([])
                return
            }
            
            reply(operations.map { $0.resultHash ?? Data() })
        }
    }
    
    private func perform<T: BaseReactorOperation>(operation: T.Type, withFilesAtPaths paths: [String], completion: @escaping ([T]?) -> Void) {
        guard let connection = connection,
              let eventingService = connection.remoteObjectProxy as? XPCFileReactorServiceEventingProtocol
        else {
            completion(nil)
            return
        }
        
        let totalOperations = UInt(paths.count)
        var completedOperations = UInt(0)
        
        // Progress tracking logic
        let operations = paths.map(T.init)
        operations.forEach { op in
            op.completionBlock = {
                // We don't need sync here, no problems if duplicate notifications will happen
                completedOperations += 1
                eventingService.notify(operationsCompleted: completedOperations, from: totalOperations)
            }
        }
        
        operationQueue.isSuspended = true
        operationQueue.addOperations(operations, waitUntilFinished: false)
        
        let barrier = BlockOperation {
            completion(operations)
            //reply(operations.map { $0.result })
        }
        operations.forEach(barrier.addDependency)
        operationQueue.addOperation(barrier)
        operationQueue.isSuspended = false
    }
    
}
