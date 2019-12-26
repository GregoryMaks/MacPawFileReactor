//
//  FileReactorService.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

protocol FileReactorServiceProtocol {
    
    typealias MultipleFilesBoolCompletionHandler = (Result<[Bool], FileReactorService.ServiceError>) -> Void
    typealias MultipleFilesDataCompletionHandler = (Result<[Data], FileReactorService.ServiceError>) -> Void
    
    func removeFiles(atURLs urls: [URL], completionHandler: @escaping MultipleFilesBoolCompletionHandler) -> ProgressTracker
    func duplicateFiles(atURLs urls: [URL], completionHandler: @escaping MultipleFilesBoolCompletionHandler) -> ProgressTracker
    func countHashSumOfFiles(atURLs urls: [URL], completionHandler: @escaping MultipleFilesDataCompletionHandler) -> ProgressTracker
    
}

class FileReactorService: FileReactorServiceProtocol {
    
    // MARK: - Types
    
    enum ServiceError: Error {
        case xpcCommunicationError(_ xpcError: Error?)
    }
    
    class ServiceEventHandler: XPCFileReactorServiceEventingProtocol {
        
        private (set) var progressTracker: ProgressTracker?
            
        func setNewProgressTracker(with totalOperationCount: UInt) {
            self.progressTracker = ProgressTracker(totalOperationCount: totalOperationCount)
        }
        
        func notify(operationsCompleted: UInt, from totalOperations: UInt) {
            progressTracker?.updateCompletedOperations(to: operationsCompleted)
        }
        
    }
    
    // MARK: - Properties
    
    lazy var fileRectorXPCConnection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: XPCFileReactorServiceName)
        connection.remoteObjectInterface = NSXPCInterface(with: XPCFileReactorServiceProtocol.self)
        connection.exportedInterface = NSXPCInterface(with: XPCFileReactorServiceEventingProtocol.self)
        
        let exportedObject = ServiceEventHandler()
        connection.exportedObject = exportedObject
        connection.resume()
        
        return connection
    }()
    
    // MARK: - Methods
    
    deinit {
        fileRectorXPCConnection.invalidate()
    }
    
    func removeFiles(atURLs urls: [URL], completionHandler: @escaping MultipleFilesBoolCompletionHandler) -> ProgressTracker {
        let eventHandler = fileRectorXPCConnection.exportedObject as? ServiceEventHandler
        
        let xpcService = fileRectorXPCConnection.remoteObjectProxyWithErrorHandler({ xpcError in
            completionHandler(.failure(.xpcCommunicationError(xpcError)))
        }) as! XPCFileReactorServiceProtocol
        
        eventHandler?.setNewProgressTracker(with: UInt(urls.count))
        
        xpcService.removeFiles(atPaths: urls.map { $0.path }) { result in
            completionHandler(.success(result))
        }
        
        return eventHandler?.progressTracker ?? ProgressTracker(totalOperationCount: 1)
    }
    
    func duplicateFiles(atURLs urls: [URL], completionHandler: @escaping MultipleFilesBoolCompletionHandler) -> ProgressTracker {
        let eventHandler = fileRectorXPCConnection.exportedObject as? ServiceEventHandler
        
        let xpcService = fileRectorXPCConnection.remoteObjectProxyWithErrorHandler({ xpcError in
            completionHandler(.failure(.xpcCommunicationError(xpcError)))
        }) as! XPCFileReactorServiceProtocol
        
        eventHandler?.setNewProgressTracker(with: UInt(urls.count))
        
        xpcService.duplicateFiles(atPaths: urls.map { $0.path }) { result in
            completionHandler(.success(result))
        }
        
        return eventHandler?.progressTracker ?? ProgressTracker(totalOperationCount: 1)
    }
    
    func countHashSumOfFiles(atURLs urls: [URL], completionHandler: @escaping MultipleFilesDataCompletionHandler) -> ProgressTracker {
        let eventHandler = fileRectorXPCConnection.exportedObject as? ServiceEventHandler
        
        let xpcService = fileRectorXPCConnection.remoteObjectProxyWithErrorHandler({ xpcError in
            completionHandler(.failure(.xpcCommunicationError(xpcError)))
        }) as! XPCFileReactorServiceProtocol
        
        eventHandler?.setNewProgressTracker(with: UInt(urls.count))
        
        xpcService.countHashSumOfFiles(atPaths: urls.map { $0.path }) { result in
            completionHandler(.success(result))
        }
        
        return eventHandler?.progressTracker ?? ProgressTracker(totalOperationCount: 1)
    }
    
}
