//
//  ReactorViewModel.swift
//  MacPawFileReactor
//
//  Created by Gregory Maksyuk on 12/24/19.
//  Copyright © 2019 Gregory Maksyuk. All rights reserved.
//

import Foundation

class ReactorViewModel {
    
    var files = [URL]()
    
    var availableOperations = Operation.allCases
    var currentOperation = Operation.remove
    var fileViewModels = [FileViewModel]()
    
    // MARK: - Bindings
    
    public var availableOperationsDidChange: (([Operation]) -> Void)?
    public var operationDidChange: ((Operation) -> Void)?
    public var filesDidChange: (([FileViewModel]) -> Void)?

}

// MARK: - Methods

extension ReactorViewModel {
    
    public func initializeBindings() {
        availableOperationsDidChange?(availableOperations)
        operationDidChange?(currentOperation)
        filesDidChange?(fileViewModels)
    }
    
    public func appendFiles(byUrls urls: [URL]) {
        files.append(contentsOf: urls)
        fileViewModels.append(contentsOf: urls.map { fileViewModel(fromUrl: $0) })
        filesDidChange?(fileViewModels)
    }
    
    public func changeOperation(to operation: Operation) {
        currentOperation = operation
        operationDidChange?(operation)
    }
    
    public func performCurrentOperation() {
        // TODO
    }
    
}

// MARK: - Private methods

extension ReactorViewModel {
    
    private func fileViewModel(fromUrl url: URL) -> FileViewModel {
        let fileName = url.lastPathComponent
        
        var sizeString = "unknown"
        let attrs = try? FileManager.default.attributesOfItem(atPath: url.path)
        if let fileSize = (attrs?[.size] as? NSNumber)?.uint64Value {
            sizeString = fileSizeText(fromByteSize: fileSize)
        }
        
        return FileViewModel(filename: fileName, size: sizeString)
    }
    
    private func fileSizeText(fromByteSize byteSize: UInt64) -> String {
        let sizes = [ "bytes", "KB", "MB", "GB", "TB" ];
        var len = Double(byteSize);
        var order = 0;
        while len >= 1024 && order < sizes.count - 1 {
            order += 1;
            len = len / 1024.0;
        }
        
        return "\(String(format: "%.2f", len)) \(sizes[order])"
    }
    
}
