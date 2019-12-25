//
//  FileReactorService.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/25/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

// TODO: all errors?
enum FileReactorServiceError: Error {
    case xpcCommunicationError(_ xpcError: Error?)
}

protocol FileReactorServiceProtocol {
    
    typealias MultipleFilesCompletionHandler = (Result<[Bool], FileReactorServiceError>) -> Void
    typealias SingleFileCompletionHandler = (Result<Bool, FileReactorServiceError>) -> Void
    
    func removeFiles(atURLs: [URL], completionHandler: @escaping MultipleFilesCompletionHandler) -> ProgressTracker
    func duplicateFiles(atURLs: [URL], completionHandler: @escaping MultipleFilesCompletionHandler) -> ProgressTracker
    func countHashSumOfFiles(atURLs: [URL], completionHandler: @escaping SingleFileCompletionHandler) -> ProgressTracker
    
}

class FileReactorService: FileReactorServiceProtocol {
    
    lazy var fileRectorXPCConnection: NSXPCConnection = {
        let connection = NSXPCConnection(serviceName: "com.gregorymaks.MacPawFileReactor.XPCFileReactorService")
        connection.remoteObjectInterface = NSXPCInterface(with: XPCFileReactorServiceProtocol.self)
        
        // TODO
//        connection.invalidationHandler = {
//        }
//        connection.interruptionHandler = {
//        }
        
        connection.resume()
        return connection
    }()
    
    deinit {
        fileRectorXPCConnection.invalidate()
    }
    
    func removeFiles(atURLs urls: [URL], completionHandler: @escaping MultipleFilesCompletionHandler) -> ProgressTracker {
        
        let xpcService = fileRectorXPCConnection.remoteObjectProxyWithErrorHandler({ xpcError in
            completionHandler(.failure(.xpcCommunicationError(xpcError)))
        }) as! XPCFileReactorServiceProtocol
        
        xpcService.removeFiles(atURLs: urls) { result in
            completionHandler(.success(result))
        }
        
        // TODO
        return ProgressTracker(totalOperationCount: 0)
    }
    
    func duplicateFiles(atURLs: [URL], completionHandler: @escaping MultipleFilesCompletionHandler) -> ProgressTracker {
        // TODO
        return ProgressTracker(totalOperationCount: 0)
    }
    
    func countHashSumOfFiles(atURLs: [URL], completionHandler: @escaping SingleFileCompletionHandler) -> ProgressTracker {
        // TODO
        return ProgressTracker(totalOperationCount: 0)
    }
    
}
